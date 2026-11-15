"""Simulación de visión cromática. Método: Machado, Oliveira & Fernandes (2009), severidad 1.0,
aplicada en RGB lineal (sRGB->lineal, matriz, lineal->sRGB). Gris: luminancia relativa Rec.709/WCAG."""
import sys, numpy as np
from PIL import Image
M = {
 'protanopia':   np.array([[0.152286,1.052583,-0.204868],[0.114503,0.786281,0.099216],[-0.003882,-0.048116,1.051998]]),
 'deuteranopia': np.array([[0.367322,0.860646,-0.227968],[0.280085,0.672501,0.047413],[-0.011820,0.042940,0.968881]]),
}
def lin(c): return np.where(c<=0.04045,c/12.92,((c+0.055)/1.055)**2.4)
def srgb(c):
    c=np.clip(c,0,1); return np.where(c<=0.0031308,c*12.92,1.055*c**(1/2.4)-0.055)
def sim(a,kind):
    L=lin(a)
    if kind=='gris':
        y=L@np.array([0.2126,0.7152,0.0722]); O=np.stack([y]*3,-1)
    else: O=L@M[kind].T
    return srgb(O)
def run(src,prefix):
    im=Image.open(src).convert('RGB'); a=np.asarray(im)/255.0; outs={'original':im}
    for k in ['gris','protanopia','deuteranopia']:
        o=Image.fromarray((sim(a,k)*255+0.5).astype(np.uint8)); o.save(f'{prefix}_{k}.png'); outs[k]=o
    w,h=im.size; sheet=Image.new('RGB',(w*4+30,h),(255,255,255))
    for i,k in enumerate(['original','gris','protanopia','deuteranopia']): sheet.paste(outs[k],(i*(w+10),0))
    sheet.save(f'{prefix}_hoja.png')
if __name__=='__main__':
    run(sys.argv[1],sys.argv[2])
