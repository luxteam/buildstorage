from flask import Flask
from flask import render_template
import json
import os


app = Flask(__name__)
APP_ROOT = os.path.dirname(os.path.abspath(__file__))


@app.route("/")
def main_page():
    listdir = os.listdir(os.path.join(APP_ROOT, 'packages'))
    return render_template('main.html', listdir=listdir, link='packages', title='Main')


@app.route("/packages/<package>")
def package_page(package):
    listdir = os.listdir(os.path.join(APP_ROOT, 'packages', package))
    return render_template('main.html', listdir=listdir, link='packages/' + package, title=package)


@app.route("/packages/<package>/<version>")
def build_page(package, version):
    listdir = os.listdir(os.path.join(APP_ROOT, 'packages', package, version))
    # return render_template('build_info.html', listdir=listdir, title=package + ' ' + version)

    report = {}
    with open(os.path.join(APP_ROOT, 'packages', package, version, 'test_results', 'session_report.json')) as file:
        report = file.read()
    report = json.loads(report)

    total = {'total': 0, 'passed': 0, 'failed': 0, 'skipped': 0, 'duration': 0}

    for result in report['results']:
        for item in report['results'][result]:
            for key in total:
                total[key] += report['results'][result][item][key]

    report.update({'summary': total})

    # downloadlink = os.path.join(APP_ROOT, 'packages', package, version, 'test_results', list(filter(lambda x: x.endswith('.exe'), listdir))[0])
    downloadlink = ' '
    
    return render_template('session_report.html', results=report['results'], total=total, downloadlink=downloadlink)


if __name__ == "__main__":
    app.run(debug=True)
