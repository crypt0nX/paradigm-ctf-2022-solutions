import json

with open("tree.json") as tree:
    tree = json.load(tree)
claims = tree["claims"]

amounts = [int(claims[claim]["amount"], 0) for claim in claims]
print(sum(amounts))