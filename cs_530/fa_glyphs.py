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


# Read in datafile specified in program call, open as .vtk.
filename = sys.argv[1]
filenamefa = sys.argv[2]

#Tensor Field
reader = vtk.vtkDataSetReader()
reader.SetFileName(HMWK_DATA_ROOT + "/" + filename)
reader.Update()

#Create a Plane to cut the data
plane1 = vtk.vtkPlane()
plane2 = vtk.vtkPlane()
plane3 = vtk.vtkPlane()
plane4 = vtk.vtkPlane()
[centerx,centery,centerz] = reader.GetOutput().GetCenter()
plane1.SetOrigin([75.,centery,centerz])
plane1.SetNormal(1,0,0)

plane2.SetOrigin([centerx,centery,80])
plane2.SetNormal(0,0,1)

#Interesting Cut down the center, shows brain stem
plane3.SetOrigin([125.,centery,centerz])
plane3.SetNormal(1,0,0)

plane4.SetOrigin([centerx,centery,centerz])
plane4.SetNormal(0,1,0)

plane1Cut=vtk.vtkCutter()
plane1Cut.SetInputConnection(reader.GetOutputPort())
plane1Cut.SetCutFunction(plane1)

onratio=5

downsampled1 = vtk.vtkMaskPoints()
downsampled1.SetInputConnection(plane1Cut.GetOutputPort())
downsampled1.SetOnRatio(onratio)
downsampled1.RandomModeOff()

plane2Cut=vtk.vtkCutter()
plane2Cut.SetInputConnection(reader.GetOutputPort())
plane2Cut.SetCutFunction(plane2)

downsampled2 = vtk.vtkMaskPoints()
downsampled2.SetInputConnection(plane2Cut.GetOutputPort())
downsampled2.SetOnRatio(onratio)
downsampled2.RandomModeOff()

plane3Cut=vtk.vtkCutter()
plane3Cut.SetInputConnection(reader.GetOutputPort())
plane3Cut.SetCutFunction(plane3)

downsampled3 = vtk.vtkMaskPoints()
downsampled3.SetInputConnection(plane3Cut.GetOutputPort())
downsampled3.SetOnRatio(onratio)
downsampled3.RandomModeOff()

plane4Cut=vtk.vtkCutter()
plane4Cut.SetInputConnection(reader.GetOutputPort())
plane4Cut.SetCutFunction(plane4)

downsampled4 = vtk.vtkMaskPoints()
downsampled4.SetInputConnection(plane4Cut.GetOutputPort())
downsampled4.SetOnRatio(onratio)
downsampled4.RandomModeOff()

probe1 = vtk.vtkProbeFilter()
probe1.SetInputConnection(downsampled1.GetOutputPort())
probe1.SetSourceConnection(reader.GetOutputPort())

probe2 = vtk.vtkProbeFilter()
probe2.SetInputConnection(downsampled2.GetOutputPort())
probe2.SetSourceConnection(reader.GetOutputPort())

probe3 = vtk.vtkProbeFilter()
probe3.SetInputConnection(downsampled3.GetOutputPort())
probe3.SetSourceConnection(reader.GetOutputPort())

probe4 = vtk.vtkProbeFilter()
probe4.SetInputConnection(downsampled4.GetOutputPort())
probe4.SetSourceConnection(reader.GetOutputPort())

glyph1 = vtk.vtkTensorGlyph()
spsource=vtk.vtkSphereSource()
spsource.SetRadius(700)
glyph1.SetSourceConnection(spsource.GetOutputPort())
glyph1.SetInputConnection(probe1.GetOutputPort())
glyph1.SetColorModeToEigenvector()
glyph1.ScalingOn()
norm1 = vtk.vtkPolyDataNormals()
norm1.SetInputConnection(glyph1.GetOutputPort())

glyph2 = vtk.vtkTensorGlyph()
glyph2.SetSourceConnection(spsource.GetOutputPort())
glyph2.SetInputConnection(probe2.GetOutputPort())
glyph2.ScalingOn()
glyph2.SetColorModeToEigenvector()
norm2 = vtk.vtkPolyDataNormals()
norm2.SetInputConnection(glyph2.GetOutputPort())

glyph3 = vtk.vtkTensorGlyph()
glyph3.SetSourceConnection(spsource.GetOutputPort())
glyph3.SetInputConnection(probe3.GetOutputPort())
glyph3.ScalingOn()
glyph3.SetColorModeToEigenvector()
norm3 = vtk.vtkPolyDataNormals()
norm3.SetInputConnection(glyph3.GetOutputPort())

glyph4 = vtk.vtkTensorGlyph()
glyph4.SetSourceConnection(spsource.GetOutputPort())
glyph4.SetInputConnection(probe4.GetOutputPort())
glyph4.ScalingOn()
glyph4.SetColorModeToEigenvector()
norm4 = vtk.vtkPolyDataNormals()
norm4.SetInputConnection(glyph4.GetOutputPort())


cut1Mapper = vtk.vtkPolyDataMapper()
cut1Mapper.SetInputConnection(norm1.GetOutputPort())

cut2Mapper = vtk.vtkPolyDataMapper()
cut2Mapper.SetInputConnection(norm2.GetOutputPort())

cut3Mapper = vtk.vtkPolyDataMapper()
cut3Mapper.SetInputConnection(norm3.GetOutputPort())

cut4Mapper = vtk.vtkPolyDataMapper()
cut4Mapper.SetInputConnection(norm4.GetOutputPort())

actor1 = vtk.vtkActor()
actor1.SetMapper(cut1Mapper)

actor2 = vtk.vtkActor()
actor2.SetMapper(cut2Mapper)

actor3 = vtk.vtkActor()
actor3.SetMapper(cut3Mapper)

actor4 = vtk.vtkActor()
actor4.SetMapper(cut4Mapper)

#FA Field
readerfa = vtk.vtkDataSetReader()
readerfa.SetFileName(HMWK_DATA_ROOT + "/" + filenamefa)
readerfa.Update()
(minfa,maxfa)=readerfa.GetOutput().GetScalarRange()

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
ren.AddActor(actor1)
ren.AddActor(actor2)
ren.AddActor(actor3)
ren.AddActor(actor4)
ren.AddVolume(volume)
actors = {'actor1':1,'actor2':1,'actor3':1,'actor4':1}

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
    plane_toggle4()
    nametofile=filename+"_dvr_three_planes"
    os.system("sleep 1")
    os.system("scrot -u -z -b "+nametofile+".png")
    RenderImage(nametofile+"_big.png")

def plane_toggle1():
    global ren,actors,actor1
    if actors['actor1']==1:
        ren.RemoveActor(actor1)
        actors['actor1']=0
        renWin.Render()
    else:
        ren.AddActor(actor1)
        actors['actor1']=1
        renWin.Render()

def plane_toggle2():
    global ren,actors,actor2
    if actors['actor2']==1:
        ren.RemoveActor(actor2)
        actors['actor2']=0
        renWin.Render()
    else:
        ren.AddActor(actor2)
        actors['actor2']=1
        renWin.Render()

def plane_toggle3():
    global ren,actors,actor3
    if actors['actor3']==1:
        ren.RemoveActor(actor3)
        actors['actor3']=0
        renWin.Render()
    else:
        ren.AddActor(actor3)
        actors['actor3']=1
        renWin.Render()

def plane_toggle4():
    global ren,actors,actor4
    if actors['actor4']==1:
        ren.RemoveActor(actor4)
        actors['actor4']=0
        renWin.Render()
    else:
        ren.AddActor(actor4)
        actors['actor4']=1
        renWin.Render()

# Create and add buttons to the gui
cmap=Tkinter.IntVar()
ctrl_buttons = Tkinter.Frame(top)
rdio_buttons = Tkinter.Frame(top)
rdio_buttons.pack(side="top", anchor="n", fill="both")
ctrl_buttons.pack(side="bottom", anchor="n", fill="both", expand="false")
plane1_radio = Tkinter.Button(rdio_buttons, text="Grey Matter Slice",
                  command=plane_toggle1)
plane2_radio = Tkinter.Button(rdio_buttons, text="Optic Chiasm Slice",
                  command=plane_toggle2)
plane3_radio = Tkinter.Button(rdio_buttons, text="Brain Stem Slice",
                  command=plane_toggle3)
plane4_radio = Tkinter.Button(rdio_buttons, text="Forward Facing Slice",
                  command=plane_toggle4)
plane1_radio.pack(side="left",expand="true",fill="x")
plane2_radio.pack(side="left",expand="true",fill="x")
plane3_radio.pack(side="left",expand="true",fill="x")
plane4_radio.pack(side="left",expand="true",fill="x")
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



