from flask import Flask, request, jsonify, send_from_directory
import mysql.connector
import boto3
from botocore.exceptions import ClientError
import os, json

app = Flask(__name__)

def get_rds_info():
    ssm_client = boto3.client('ssm', region_name='us-east-1')
    parameter_name = '/staging/rds_info'
    response = ssm_client.get_parameter(Name=parameter_name, WithDecryption=True)
    parameter_value = response['Parameter']['Value']
    return parameter_value.split("~")

endpoint_name, secret_arn = get_rds_info() 
endpoint_name = endpoint_name.split(":")[0]

def get_secret():
    

    region_name = os.environ.get('AWS_REGION', 'us-east-1')

    # Create a Secrets Manager client
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )

    try:
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_arn
        )
    except ClientError as e:
        # For a list of exceptions thrown, see
        # https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_GetSecretValue.html
        raise e

    # Decrypts secret using the associated KMS key.
    secret = get_secret_value_response['SecretString']
    return json.loads(secret)

db_secret = get_secret()

# Configure MySQL connection
# mysql -h demodb.c0kwvqqmo5vv.us-east-1.rds.amazonaws.com -P 3306 -u admin -p
db = mysql.connector.connect(
    host=endpoint_name,
    user=db_secret['username'],
    password=db_secret['password'],
    database="demodb"
)

# Create a cursor object to execute SQL queries
cursor = db.cursor()

# Create a table if it doesn't exist
cursor.execute("CREATE TABLE IF NOT EXISTS users (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), email VARCHAR(255))")

@app.route('/', methods=['GET'])
def index():
    # Serve the index.html file from the 'static' directory
    return send_from_directory('templates', 'index.html')

@app.route('/users', methods=['GET'])
def get_users():
    # Retrieve all users from the database
    cursor.execute("SELECT * FROM users")
    result = cursor.fetchall()

    # Convert the result to a list of dictionaries
    users = []
    for row in result:
        user = {'id': row[0], 'name': row[1], 'email': row[2]}
        users.append(user)

    return jsonify(users)

@app.route('/users', methods=['POST'])
def create_user():
    # Get user data from the request body
    data = request.get_json()
    name = data['name']
    email = data['email']

    # Insert the new user into the database
    cursor.execute("INSERT INTO users (name, email) VALUES (%s, %s)", (name, email))
    db.commit()

    return jsonify({'message': 'User created successfully'})

@app.route('/users/<int:user_id>', methods=['GET'])
def get_user(user_id):
    # Retrieve a specific user from the database
    cursor.execute("SELECT * FROM users WHERE id = %s", (user_id,))
    result = cursor.fetchone()

    if result is None:
        return jsonify({'message': 'User not found'})

    user = {'id': result[0], 'name': result[1], 'email': result[2]}
    return jsonify(user)

@app.route('/users/<int:user_id>', methods=['PUT'])
def update_user(user_id):
    # Get user data from the request body
    data = request.get_json()
    name = data['name']
    email = data['email']

    # Update the user in the database
    cursor.execute("UPDATE users SET name = %s, email = %s WHERE id = %s", (name, email, user_id))
    db.commit()

    return jsonify({'message': 'User updated successfully'})

@app.route('/users/<int:user_id>', methods=['DELETE'])
def delete_user(user_id):
    # Delete the user from the database
    cursor.execute("DELETE FROM users WHERE id = %s", (user_id,))
    db.commit()

    return jsonify({'message': 'User deleted successfully'})

if __name__ == '__main__':
    # app.static_folder = os.path.abspath("static")
    app.run(port=8080,host='0.0.0.0')
