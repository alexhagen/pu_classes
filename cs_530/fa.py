#!/usr/bin/env python

# See PDF Writeup (CS_530_HMWK_5.pdf) for details

# Import needed modules:  vtk for visualization,
# sys for writing files, tkinter for gui
import vtk
import sys
import os
import Tkinter
from math import *
from vtk.tk.vtkTkRenderWindowInteractor import \
     vtkTkRenderWindowInteractor
from vtk.util.misc import vtkGetDataRoot
# Set data paths
VTK_DATA_ROOT = vtkGetDataRoot()
HMWK_DATA_ROOT = "./"


filenamefa = sys.argv[1]

#FA Field
readerfa = vtk.vtkDataSetReader()
readerfa.SetFileName(HMWK_DATA_ROOT + "/" + filenamefa)
readerfa.Update()
(minfa,maxfa)=readerfa.GetOutput().GetScalarRange()
[centerx,centery,centerz] = readerfa.GetOutput().GetCenter()

# Create transfer mapping scalar value to opacity
opacityTransferFunction = vtk.vtkPiecewiseFunction()
opacityTransferFunction.AddPoint(minfa, 0.0)
opacityTransferFunction.AddPoint(10000.,0.003)
opacityTransferFunction.AddPoint(48000.,0.02)
opacityTransferFunction.AddPoint(maxfa,0.2)

#Set a colormap - Plain White
colormap = vtk.vtkColorTransferFunction()
colormap.SetRange((minfa,maxfa))
colormap.AddRGBPoint(minfa,255./255.,255./255.,255./255.)
colormap.AddRGBPoint(maxfa,255./255.,255./255.,255./255.)

# The property describes how the data will look
volumeProperty = vtk.vtkVolumeProperty()
volumeProperty.SetColor(colormap)
volumeProperty.SetScalarOpacity(opacityTransferFunction)
volumeProperty.ShadeOn()
volumeProperty.SetInterpolationTypeToLinear()

# The mapper / ray cast function know how to render the data
compositeFunction = vtk.vtkVolumeRayCastCompositeFunction()
volumeMapper = vtk.vtkVolumeRayCastMapper()
volumeMapper.SetVolumeRayCastFunction(compositeFunction)
volumeMapper.SetInputConnection(readerfa.GetOutputPort())
volumeMapper.SetSampleDistance(0.3)

# The volume holds the mapper and the property and
# can be used to position/orient the volume
volume = vtk.vtkVolume()
volume.SetMapper(volumeMapper)
volume.SetProperty(volumeProperty)

# Create renderer
ren = vtk.vtkRenderer()
renWin = vtk.vtkRenderWindow()
renWin.AddRenderer(ren)
ren.SetBackground(1.0,1.0,1.0)
ren.AddVolume(volume)

# Create tkinter GUI
root = Tkinter.Tk()
root.withdraw()
top = Tkinter.Toplevel(root)

# Create window fro visualzation and add to gui
display_frame = Tkinter.Frame(top)
display_frame.pack(side="top", anchor="n", fill="both", expand="false")
renderer_frame = Tkinter.Frame(display_frame)
renderer_frame.pack(padx=3, pady=3,side="left", anchor="n",
                    fill="both", expand="false")
render_widget = vtkTkRenderWindowInteractor(renderer_frame,
                                            rw=renWin, width=800,
                                            height=600)
for i in (render_widget, display_frame):
    i.pack(side="top", anchor="n",fill="both", expand="false")


# Define a quit method that exits cleanly.
def quit(obj=root):
    obj.quit()

def RenderImage(filename):
    global ren
    w2i = vtk.vtkRenderLargeImage()
    writer = vtk.vtkPNGWriter()
    w2i.SetInput(ren)
    w2i.SetMagnification(3)
    w2i.Update()
    writer.SetInputConnection(w2i.GetOutputPort())
    writer.SetFileName(filename)
    renWin.Render()
    writer.Write()

# Render a large image and place in a png
def CaptureImage():
    global ren,renWin,filename
    nametofile=filenamefa+"_dvr_no_planes"
    os.system("sleep 1")
    os.system("scrot -u -z -b "+nametofile+".png")
    RenderImage(nametofile+"_big.png")


# Create and add buttons to the gui
cmap=Tkinter.IntVar()
ctrl_buttons = Tkinter.Frame(top)
rdio_buttons = Tkinter.Frame(top)
rdio_buttons.pack(side="top", anchor="n", fill="both")
ctrl_buttons.pack(side="bottom", anchor="n", fill="both", expand="false")
capture_button = Tkinter.Button(ctrl_buttons, text="Export Magnified Image to File",
                                command=CaptureImage)
capture_button.pack(side="left",fill="x",expand="true")
quit_button = Tkinter.Button(ctrl_buttons, text="Click Here to Quit", command=quit)
quit_button.pack(side="left",expand="true", fill="x")

# Create a view, parallel projection so no perspective
cam1 = ren.GetActiveCamera()
cam1.ParallelProjectionOn()
cam1.SetViewUp(0, 0, 1)
cam1.SetFocalPoint(centerx,centery,centerz)
cam1.SetPosition(-113,-553,360)
cam1.Zoom(1.75)
ren.ResetCameraClippingRange()

# Render and start vis interactivity
render_widget.Render()
iact = render_widget.GetRenderWindow().GetInteractor()
iact.Initialize()
iact.Start()

# Start GUI interactivity
root.mainloop()



