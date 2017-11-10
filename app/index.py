from flask import Flask
from flask import render_template
import json
import os

app = Flask(__name__)

@app.route("/")
def main_page():
	listdir = os.listdir(os.path.abspath('packages'))
	return render_template('main.html', listdir=listdir, link='packages', title='Main')


@app.route("/packages/<package>")
def package_page(package):
	listdir = os.listdir(os.path.abspath(os.path.join('packages', package)))
	return render_template('main.html', listdir=listdir, link='packages/' + package, title=package)


@app.route("/packages/<package>/<version>")
def build_page(package, version):
	listdir = os.listdir(os.path.abspath(os.path.join('packages', package, version)))
	return render_template('build_info.html', listdir=listdir, title=package + ' ' + version)


if __name__ == "__main__":
    app.run(debug=True)
