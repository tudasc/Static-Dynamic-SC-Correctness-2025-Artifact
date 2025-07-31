import json
import sys

data = json.load(open(sys.argv[1], 'r'))

total_messages = len(data['messages'])
local_data_race_messages = len([msg for msg in data['messages'] if 'Local Data Race' in msg["type"]])

print(f"Total messages: {total_messages}")
print(f"Local Data Race messages: {local_data_race_messages}")