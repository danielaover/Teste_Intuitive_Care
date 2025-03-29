# import necessary libraries

from flask import Flask, jsonify
import pandas as pd

# create a Flask application instance

app = Flask(__name__)

# define a route to access data using the GET method

@app.route('/dados', methods=['GET'])
def obter_dados():
    try:
        
         # read the CSV file named 'dados.csv' and convert it into a Pandas DataFrame
        df = pd.read_csv('dados.csv')
        dados = df.to_dict(orient='records')
        
        # convert the DataFrame data into a list of dictionaries
        return jsonify(dados)
    except FileNotFoundError:
        return jsonify({'erro': 'Arquivo CSV não encontrado'}), 404


# start the flask server when the script is run directly

if __name__ == '__main__':
    app.run(debug=True)