import psutil


class FindVideo:

    def __init__(self):
        pass

    def getvideo(self):
        for pid in psutil.get_pid_list():
            ps = psutil.Process(pid)
            if ps.name == 'mplayer':
                return ps.cmdline[-1]
        raise Exception("No mplayer command found")
