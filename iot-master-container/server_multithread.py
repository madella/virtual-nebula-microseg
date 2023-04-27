from socketserver import ThreadingTCPServer,StreamRequestHandler

class echohandler(StreamRequestHandler):
    def handle(self):
        print(f'Connected: {self.client_address[0]}:{self.client_address[1]}')
        while True:
            msg = self.rfile.readline()
            print(msg.decode())
            if not msg:
                print(f'Disconnected: {self.client_address[0]}:{self.client_address[1]}')
                break # exits handler, framework closes socket
            self.wfile.write(msg)
            self.wfile.flush()

server = ThreadingTCPServer(('0.0.0.0',1883),echohandler)
server.serve_forever()