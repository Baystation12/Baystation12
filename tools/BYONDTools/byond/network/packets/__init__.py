"""
BYOND Base Packet Class

Created with help from tobba.
"""
import logging, struct

class NetTypes:
    BYTE = 0
    SHORT = 1
    LONG = 2
    STRING = 3
    
    min_lens = [1, 2, 4, None]
    
    @staticmethod
    def GetMinLength(t):
        return NetTypes.min_lens[t]

PacketTypes = {}

class Packet:
    ID = 0
    Name = ''
    def __init__(self):
        self.__field_data = {}
        self.header = {}
        self.min_length = 0
        
        self.length = 0
        self.sequence = 0
    
    def LinkField(self, datatype, propname, **kwargs):
        '''
        Associate a part of a packet to a field in this class
        '''
        kwargs['type'] = datatype
        kwargs['name'] = propname
        self.__field_data[len(self.__field_data)] = kwargs
        self.min_length += NetTypes.GetMinLength(datatype)
    
    def Deserialize(self, msg):
        if len(msg) < self.min_length:
            logging.error('Received truncated packet {0}: min_length={1}, msg.len={2}'.format(self.Name, self.min_length, len(msg)))
            
        # TIME FOR ASSUMPTIONS!
        pos = 0
        for idx, fieldinfo in self.__field_data.items():
            dtype = fieldinfo['type']
            propname = fieldinfo['name']
            unpacked = None
            if dtype == NetTypes.BYTE:
                dat = msg[pos:pos + 1]
                unpacked = struct.unpack('B', dat)  # Unsigned char
                pos += 1
            elif dtype == NetTypes.SHORT:
                dat = msg[pos:pos + 2]
                unpacked = struct.unpack('h', dat)  # short (maybe H?)
                pos += 2
            elif dtype == NetTypes.LONG:
                dat = msg[pos:pos + 4]
                unpacked = struct.unpack('l', dat)  # short (maybe L?)
                pos += 4
            elif dtype == NetTypes.STRING:
                dat = msg[pos:]
                unpacked = dat.split('\x00', 1)
                pos += len(unpacked) + 1  # NUL byte stripped
            else:
                logging.error('Unable to unpack {0} packet at field {1}: Unknown datatype {2}'.format(self.Name, idx, dtype))
                logging.error('Packet __field_data:'.repr(self.__field_data))
                raise SystemError()
            setattr(self, propname, unpacked)
    
    def Serialize(self):            
        msg = b''
        for idx, fieldinfo in self.__field_data.items():
            dtype = fieldinfo['type']
            dat = getattr(self, fieldinfo['name'])
            if dtype == NetTypes.BYTE:
                msg += struct.pack('B', dat)  # Unsigned char
            elif dtype == NetTypes.SHORT:
                msg += struct.pack('h', dat)  # short (maybe H?)
            elif dtype == NetTypes.LONG:
                msg += struct.pack('l', dat)  # short (maybe L?)
            elif dtype == NetTypes.STRING:
                msg += dat + b'\x00'
            else:
                logging.error('Unable to pack {0} packet at field {1}: Unknown datatype {2}'.format(self.Name, idx, dtype))
                logging.error('Packet __field_data:'.repr(self.__field_data))
                raise SystemError()
        return msg
