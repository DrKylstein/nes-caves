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
            for x in range(layers['Names'].width()):
                for y in range(layers['Names'].height()):
                    cell = layers['Names'].cellAt(x, y)
                    out.write(chr(cell.tile.id()))
        return True
