from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)


@app.route('/')
def hello_world():  # put application's code here
    return 'Hello World!'


@app.route('/products')
def getProduct():
    # Define product data with videos as dictionaries
    product_list = [
        {
            "id": 1,
            "title": 'Flutter course',
            "author": 'Created by Dear Programmer',
            "videoCount": 4,
            "imageUrl": 'https://images.ctfassets.net/23aumh6u8s0i/4TsG2mTRrLFhlQ9G1m19sC/4c9f98d56165a0bdd71cbe7b9c2e2484/flutter',
            "videos": [
                {"title": 'Introduction to Flutter', "duration": '20 min'},
                {"title": 'Installing Flutter on Windows', "duration": '15 min'},
                {"title": 'Setup Emulator on Windows', "duration": '10 min'},
                {"title": 'Creating Our First App', "duration": '25 min'}
            ],
        },
        {
            "title": 'React Native Course',
            "author": 'Created by Dev Instructor',
            "videoCount": 2,
            "imageUrl": 'https://w7.pngwing.com/pngs/79/518/png-transparent-js-react-js-logo-react-react-native-logos-icon-thumbnail.png',
            "videos": [
                {"title": 'Getting Started with React Native', "duration": '22 min'},
                {"title": 'Setting Up React Native on Mac', "duration": '19 min'}
            ]
        }
    ]
    # Return the product list as JSON
    return jsonify(product_list)


if __name__ == '__main__':
    app.run()
