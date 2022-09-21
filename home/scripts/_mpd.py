from mpd import MPDClient, CommandError

client = MPDClient()
client.connect('localhost', 6600)
client.password('B7WtKLYaAw7wVf4p')
