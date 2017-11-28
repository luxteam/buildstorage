from flask import Flask
from flask import render_template

import json
import os

# TODO: add try-catch when working with files

app = Flask(__name__)
APP_ROOT = os.path.dirname(os.path.abspath(__file__))
CONTENT_ROOT = 'builds'


@app.route("/")
def main_page():
    listdir = os.listdir(os.path.join(APP_ROOT, CONTENT_ROOT))
    link = ''

    return render_template('folders_tree.html', title='RPR CIS', dirs=listdir, link=link)


@app.route("/<path:directory>/")
def directory_page(directory):

    listdir = os.listdir(os.path.join(APP_ROOT, CONTENT_ROOT, directory))
    link = directory

    if not 'build.manifest.json' in listdir:
        return render_template('folders_tree.html', title='RPR CIS', dirs=listdir, link=link)
    else:
        summary_json = {}
        temp_json = []
        total = {'total': 0, 'passed': 0, 'failed': 0, 'skipped': 0, 'duration': 0}

        for path, dirs, files in os.walk(os.path.join(APP_ROOT, CONTENT_ROOT, directory)):
            for file in files:
                if file == 'session_report.json':
                    with open(os.path.join(path,file), 'r') as json_file:
                        temp_json = json_file.read()
                    temp_json = json.loads(temp_json)

                    for result in temp_json['results']:
                        for item in temp_json['results'][result]:
                            for key in total:
                                total[key] += temp_json['results'][result][item][key]

                    summary_json.update({os.path.basename(path): total})
                    total = {'total': 0, 'passed': 0, 'failed': 0, 'skipped': 0, 'duration': 0}

        return render_template('build_info.html', dirs=listdir, link=link, title='BUILD info', listdir_info=summary_json)


# @app.route("/products/builds/<package>/<version>/<name>")
# def session_report_page(package, version, name):

#     report = {}
#     with open(os.path.join(APP_ROOT, 'products', package, version, name, 'session_report.json')) as file:
#         report = file.read()
#     report = json.loads(report)

#     total = {'total': 0, 'passed': 0, 'failed': 0, 'skipped': 0, 'duration': 0}

#     for result in report['results']:
#         for item in report['results'][result]:
#             for key in total:
#                 total[key] += report['results'][result][item][key]

#     report.update({'summary': total})

#     download_link = ' '

#     return render_template('session_report.html', results=report['results'], total=total, download_link=download_link, execution_name=name)

# @app.route("/products/builds/<package>/<version>/<name>/<path:test_path>/result.json")
# def one_test_result_page(package, version, name, test_path):

#     # report = []
#     # with open(os.path.join(APP_ROOT, 'products', package, version, name, test_path, 'report_compare.json')) as file:
#     #     report = file.read()
#     # report = json.loads(report)

#     # # print(report)

#     # not_rendered_report = []
#     # try:
#     #     with open(os.path.join(APP_ROOT, 'products', package, version, name, test_path, 'not_rendered.json')) as file:
#     #         not_rendered_report = file.read()
#     #     not_rendered_report = json.loads(not_rendered_report)
#     # except:
#     #     pass

#     # return render_template('template.html', title='TestResult', rendered=report, not_rendered=not_rendered_report)
#     return 'here will be test report page'


if __name__ == "__main__":
    # TODO: debug=False to release
    app.run(debug=True)
