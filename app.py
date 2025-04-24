import datetime
from datetime import datetime
from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy

# Activating Virtual Environment : .\venv\Scripts\Activate
# Leave venv : deactivate

app = Flask(__name__)

# Creating database using SQLite
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///questify.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# Creating model for task object

class Task(db.Model):

    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable = False)
    description = db.Column(db.String(200))
    latitude = db.Column(db.Float)
    longitude = db.Column(db.Float)
    completed = db.Column(db.Boolean, default=False)


    def __repr__(self):
        return f'Task : {self.title}'

# Creating model for completed task object
class CompletedTask(db.Model):

    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100),nullable=False)
    time_completed = db.Column(db.DateTime, default=datetime.utcnow)

    def __repr__(self):
        return f'Completed Task : {self.title}'


# Method for adding a task to database
@app.route("/tasks", methods=["POST"])
def add_task():
    data = request.json # Grabs json data sent from postman or the frontend

    # Check for valid data: Must contain title
    if not data or not 'title' in data:

        return jsonify({'error' : 'Title is required'}), 400

    # Create a new task object using data from POST Request

    new_task = Task(
        title = data['title'],
        description = data.get('description'),
        latitude = data.get('latitude'),
        longitude = data.get('longitude'),
        completed = False
    )

    # Add task to database
    db.session.add(new_task)

    print(new_task.__repr__())

    # Commit change to database
    db.session.commit()

    return jsonify({
        "id": new_task.id,
        "title": new_task.title,
        "description": new_task.description,
        "latitude": new_task.latitude,
        "longitude": new_task.longitude,
        "completed": new_task.completed
    }), 201


# Method for retrieving all uncompleted tasks in database
@app.route("/tasks", methods=["GET"])
def get_tasks():

    # A Query just means asking the database for information
    # I use a query here to ask for all the task objects in the database
    tasks = Task.query.all()

    # Converting each task into a dictionary

    tasks_list = []
    for task in tasks:

        tasks_list.append({
            "id" : task.id,
            "title" : task.title,
            "description" : task.description,
            "latitude" : task.latitude,
            "longitude" : task.longitude,
            "completed" : task.completed
        })

    return jsonify(tasks_list), 200

# Method for retrieving all completed tasks
@app.route("/completedtasks",methods=["GET"])
def get_completed_tasks():

    completed_tasks = CompletedTask.query.all()

    completed_list = []

    for i in completed_tasks:

        completed_list.append({

            'id' : i.id,
            'title' : i.title,
            'completed' : True
        })

    return jsonify(completed_list), 200





# Method for getting a task by it's id
@app.route("/tasks/<int:desired_id>", methods=["GET"])
def get_task_by_id(desired_id):

    print(desired_id)

    desired_task = db.session.get(Task, desired_id)

    if not desired_task:

        return jsonify({"error" : "Task not found"}), 404

    return jsonify(desired_task.title), 200


# Method for removing tasks
@app.route("/tasks/<int:desired_id>", methods=["DELETE"])
def remove_task(desired_id):

    desired_task = db.session.get(Task, desired_id)

    if not desired_task:

        return jsonify({"error" : "Task not found"}), 404

    db.session.delete(desired_task)

    db.session.commit()

    return jsonify({"message" : "Task deleted"}), 200


# Method for completing task
@app.route("/tasks/<int:completed_id>", methods=["POST"])
def complete_task(completed_id):

    just_finished = db.session.get(Task, completed_id)

    if not just_finished:

        return jsonify({'error' : 'task not found'}), 404

    # Turning completed_task into a CompletedTask object
    completed_task = CompletedTask(
        title=just_finished.title
    )

    # Calling remove_task() on the completed task
    remove_task(completed_id)

    # Adding the completed task to the database
    db.session.add(completed_task)

    db.session.commit()

    return jsonify({"message" : f'Task Completed : {completed_task.title}'}), 200






'''
Creating home route. Whenever a user visits the home url they
will be sent back this function.
'''
@app.route('/')
def home():
    return 'Welcome to Questify!'


if __name__ == '__main__':

    with app.app_context():
        db.create_all()
    app.run(debug=True)   # Starting the server

