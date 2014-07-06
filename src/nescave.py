'''
Raw binary export for Tiled
2014 <dr.kylstein@gmail.com>

'''
from tiled import *
from tiled.qt import *

class NesCave(Plugin):
        
    @classmethod
    def nameFilter(cls):
        return 'Nes Cave (*.bin)'

    @classmethod
    def supportsFile(cls, f):
        return False
        
    @classmethod
    def read(cls, f):
        return None
          
    @classmethod
    def write(cls, m, f):
        
        layers = {'Names':None}#, "Attributes":None}
        
        for layer in [m.layerAt(i) for i in range(m.layerCount())]:
            for key in layers:
                if layer.name() == key:
                    layers[key] = layer.asTileLayer()

        for key, item in layers.items():
            if item is None:
                print 'Missing layer "{}"!'.format(key)
                return False
            
        with open(f, 'wb') as out:
            for y in range(layers['Names'].height()):
                for x in range(layers['Names'].width()):
                    cell = layers['Names'].cellAt(x, y)
                    out.write(chr(cell.tile.id()))
            #~ for y in range(layers['Attributes'].height()/2):
                #~ for x in range(layers['Attributes'].width()/2):
                    #~ data = 0
                    #~ for offsets in ((0,0),(1,0),(0,1),(1,1)):
                        #~ cell = layers['Attributes'].cellAt(x*2 + offsets[0], y*2 + offsets[1])
                        #~ if cell is not None and cell.tile is not None:
                            #~ data |= cell.tile.id()
                        #~ data << 2
                    #~ out.write(chr(data))
        return True
