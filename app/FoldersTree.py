import os


def get_tree_dict(path, link):
    tree = dict(name=os.path.basename(path), children=[], link=link)

    try:
        listdir = os.listdir(path)
    except OSError:
        pass
    else:
        for item in listdir:
            if os.path.isdir(os.path.join(path, item)):
                if 'build.manifest.json' in os.listdir(os.path.join(path, item)):
                    tree['children'].append(dict(name=item, link=link + item + '/'))
                else:
                    tree['children'].append(get_tree_dict(os.path.join(path, item), link + item + '/'))
    return tree
