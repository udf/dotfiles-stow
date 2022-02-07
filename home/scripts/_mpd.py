from mpd import MPDClient, CommandError

client = MPDClient()
client.timeout = 1
client.connect('localhost', 6600)
client.password('B7WtKLYaAw7wVf4p')
