from time import sleep
class PNCL:
    def __init__(self, axi_uartlite, timeout=500):
        self._uart = axi_uartlite
        self._rx_buffer = []
        self._counter = 0
        self._timeout = timeout
        self.send("\r")
    def send(self, string):
        tx_buffer = list(bytes(string, encoding='utf-8')+b'\r')
        self._rx_buffer = []
        self._counter = 0
        tx_length = len(tx_buffer)
        for i in range(tx_length):
            data_write = tx_buffer[i]
            self._uart.write(0x4, data_write)
        while True:
            uart_status = self._uart.read(0x8)
            if (uart_status & 0x1 == 0x1):
                self._counter = 0
                data_read = self._uart.read(0x0)
                self._rx_buffer.append(data_read)
            else:
                sleep(0.001)
                self._counter += 1
                if (self._counter >= self._timeout):
                    break
    def read(self):
        line = b''
        for i in range(len(self._rx_buffer)):
            if self._rx_buffer[i] == 0x0d:
                print(line.decode())
                line = b''
            else:
                line += self._rx_buffer[i].to_bytes(1, byteorder='big')
    def cmd(self, string):
        self.send(string)
        self.read()
    
    def load(self, config):
        self.cmd("")
        for key in config:
            command = key + "=" + str(config[key])
            print("Setting %s "%command, end='')
            self.cmd(command)

            
CONFIG_MAX_SPEED = {
    "sync": 0,
    "clnk": 0,
    "tprd": 49,
    "lrps": 20409,
    "texp": 3.5,
    "dmod": 0,
    "hdir": 0,
    "binn": 0,
    "dign": 1,
    "dios": 0,
    "ffcr": 0,
    "ffcm": 0,
    "sroi": 0,
    "lscr": 0,
    "doff": 2,
    "angn": 1,
}

