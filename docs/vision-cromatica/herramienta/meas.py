import numpy as np
from PIL import Image
def L(c):
    c=np.asarray(c)/255.0; c=np.where(c<=0.04045,c/12.92,((c+0.055)/1.055)**2.4); return float(c@[0.2126,0.7152,0.0722])
def cr(a,b):
    la,lb=L(a),L(b); h,l=max(la,lb),min(la,lb); return (h+.05)/(l+.05)
def darkest(im,box):
    x0,y0,x1,y1=box; a=np.asarray(im.crop(box)).reshape(-1,3); i=np.argmin([L(p) for p in a]); return a[i]
def lightest(im,box):
    x0,y0,x1,y1=box; a=np.asarray(im.crop(box)).reshape(-1,3); i=np.argmax([L(p) for p in a]); return a[i]
# regiones (px @1x) P04-V2
R={'borde campo Nombre (error)':(150,372,250,380),'borde campo Hora':(150,520,250,528),
   'texto título error':(74,199,290,219),'texto cuerpo error':(74,227,310,245),'mensaje bajo campo':(44,438,350,456),
   'borde tarjeta error':(150,177,250,183),'borde Cancelar':(30,770,160,778),'borde Diariamente (sel.)':(150,672,250,680)}
for k in ['original','gris','protanopia','deuteranopia']:
    im=Image.open(f'P04V2_{k}.png').convert('RGB'); print('==',k)
    bg=im.getpixel((200,400))  # interior campo error
    bgh=im.getpixel((200,550))
    for n,b in R.items():
        d=darkest(im,b); ref=bgh if 'Hora' in n else bg
        print(f'{n:30s} oscuro={tuple(d)} L={L(d):.3f}')
    e=darkest(im,R['borde campo Nombre (error)']);h=darkest(im,R['borde campo Hora'])
    print('contraste borde error vs borde Hora:',round(cr(e,h),2),'| error vs interior',round(cr(e,bg),2),'| Hora vs interior',round(cr(h,bgh),2))
    t=darkest(im,R['texto título error']);c=darkest(im,R['texto cuerpo error']);print('título vs cuerpo:',round(cr(t,c),2),' L',round(L(t),3),round(L(c),3))
