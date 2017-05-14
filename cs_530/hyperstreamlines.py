#!/usr/bin/env python

# See PDF Writeup (CS_530_HMWK_5.pdf) for details

# Import needed modules:  vtk for visualization,
# sys for writing files, tkinter for gui
import vtk
import os
import sys
import Tkinter
from vtk.tk.vtkTkRenderWindowInteractor import \
     vtkTkRenderWindowInteractor
from vtk.util.misc import vtkGetDataRoot
# Set data paths
VTK_DATA_ROOT = vtkGetDataRoot()
HMWK_DATA_ROOT = "./"
VTK_INTEGRATE_BOTH_DIRECTIONS = 2

# Read in datafile specified in program call, open as .vtk.
filename = sys.argv[1]

#Tensor Field
reader = vtk.vtkDataSetReader()
reader.SetFileName(HMWK_DATA_ROOT + "/" + filename)
reader.Update()
data_range=reader.GetOutput().GetScalarRange()
[centerx,centery,centerz] = reader.GetOutput().GetCenter()
length = reader.GetOutput().GetLength()
#[minVelocity,maxVelocity] =reader.GetOutput().GetPointData().GetVectors().GetRange()
maxTime = 1000#35.0*length/maxVelocity

#making a float array by extracting the determinant
dets = vtk.vtkExtractTensorComponents()
dets.SetInputConnection(reader.GetOutputPort())
dets.SetScalarModeToEffectiveStress()
dets.ExtractScalarsOn()
dets.ExtractVectorsOff()
dets.Update()

#Dummy Array for Scalars
dummyarray = dets.GetOutput().GetPointData().GetScalars()
mindet,maxdet = dets.GetOutput().GetScalarRange()
pd = reader.GetOutput()
pd.GetPointData().SetScalars(dummyarray)

plane2 = vtk.vtkPlane()
plane2.SetOrigin([centerx,centery,80])
plane2.SetNormal(0,0,1)
onratio=5
plane2Cut=vtk.vtkCutter()
plane2Cut.SetInputConnection(dets.GetOutputPort())
plane2Cut.SetCutFunction(plane2)
thresh2 = vtk.vtkThreshold()
thresh2.SetInputConnection(plane2Cut.GetOutputPort())
thresh2.ThresholdByUpper(0.00001)
geo2 = vtk.vtkGeometryFilter()
geo2.SetInputConnection(thresh2.GetOutputPort())
cut2Mapper = vtk.vtkPolyDataMapper()
cut2Mapper.SetInputConnection(geo2.GetOutputPort())
actor2 = vtk.vtkActor()
actor2.SetMapper(cut2Mapper)
actor2.GetProperty().SetOpacity(0.5)
delta = 120-centerx

# Create a colormap
colormap = vtk.vtkColorTransferFunction()
colormap.AddRGBPoint(mindet,0./255.,0./255.,255./255.) #Blue
colormap.AddRGBPoint(mindet+(maxdet-mindet)/2, 0./255.,255./255.,0./255.) #Green
colormap.AddRGBPoint(maxdet,255./255.,0./255.,0./255.) #Full Red
cut2Mapper.SetLookupTable(colormap)

# Create a colorbar
scalarBar = vtk.vtkScalarBarActor()
scalarBar.SetMaximumWidthInPixels(800)
scalarBar.SetOrientationToHorizontal()
scalarBar.SetMaximumHeightInPixels(50)
scalarBar.SetLookupTable(cut2Mapper.GetLookupTable())
scalarBar.SetTitle("Effective Stress")
scalarBar.SetNumberOfLabels(3)

# Create renderer
ren = vtk.vtkRenderer()
renWin = vtk.vtkRenderWindow()
renWin.AddRenderer(ren)
ren.SetBackground(1.0,1.0,1.0)
ren.AddActor(actor2)
ren.AddActor2D(scalarBar)

#Integrate along the line
for k in range(-10,10,2):
    for i in range(-5,5):
        streamer1 = vtk.vtkHyperStreamline()
        streamer1.SetInputData(pd)
        streamer1.SetStartPosition(centerx+i,centery+k,centerz)
        streamer1.IntegrateMajorEigenvector()
        streamer1.SetMaximumPropagationDistance(1000.0)
        streamer1.SetIntegrationStepLength(.01)
        streamer1.SetStepLength(.01)
        streamer1.SetRadius(1)
        streamer1.SetNumberOfSides(18)
        streamer1.LogScalingOff()
        streamer1.SetIntegrationDirection(VTK_INTEGRATE_BOTH_DIRECTIONS)
        mapStreamTube1 = vtk.vtkPolyDataMapper()
        mapStreamTube1.SetInputConnection(streamer1.GetOutputPort())
        mapStreamTube1.SetLookupTable(colormap)
        streamTubeActor1 = vtk.vtkActor()
        streamTubeActor1.SetMapper(mapStreamTube1)
        ren.AddActor(streamTubeActor1)

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

def view_toggle1():
    global cam1,ren,view
    if view is not 'view1':
        if view is 'view3':
            cam1.SetFocalPoint(centerx,centery,centerz)
            cam1.Zoom(0.2)
        cam1.SetPosition(750,350,400)
        renWin.Render()
        view='view1'

def view_toggle2():
    global cam1,ren,view
    if view is not 'view2':
        if view is 'view3':
            cam1.SetFocalPoint(centerx,centery,centerz)
            cam1.Zoom(0.2)
        cam1.SetPosition(645,185,35)
        renWin.Render()
        view='view2'

def view_toggle3():
    global cam1,ren,view
    if view is not 'view3':
        cam1.SetPosition(645,185,35)
        cam1.SetFocalPoint(centerx,80.,105.)
        cam1.Zoom(5)
        renWin.Render()
        view='view3'

def CaptureImage():
    global ren,renWin,filename
    view_toggle1()
    nametofile=filename+"_side_view"
    os.system("sleep 1")
    os.system("scrot -u -z -b "+nametofile+".png")
    RenderImage(nametofile+"_big.png")

    view_toggle2()
    nametofile=filename+"_iso_view"
    os.system("sleep 1")
    os.system("scrot -u -z -b "+nametofile+".png")
    RenderImage(nametofile+"_big.png")

    view_toggle3()
    nametofile=filename+"_close_view"
    os.system("sleep 1")
    os.system("scrot -u -z -b "+nametofile+".png")
    RenderImage(nametofile+"_big.png")
    

# Create and add buttons to the gui
view = 'view2'
cmap=Tkinter.IntVar()
ctrl_buttons = Tkinter.Frame(top)
rdio_buttons = Tkinter.Frame(top)
rdio_buttons.pack(side="top", anchor="n", fill="both")
ctrl_buttons.pack(side="bottom", anchor="n", fill="both", expand="false")
view1_radio = Tkinter.Button(rdio_buttons, text="Isometric View",
                  command=view_toggle1)
view2_radio = Tkinter.Button(rdio_buttons, text="Side View",
                  command=view_toggle2)
view3_radio = Tkinter.Button(rdio_buttons, text="Front Close Up",
                  command=view_toggle3)
view1_radio.pack(side="left",expand="true",fill="x")
view2_radio.pack(side="left",expand="true",fill="x")
view3_radio.pack(side="left",expand="true",fill="x")
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
cam1.SetPosition(645,185,35)
cam1.Zoom(1.75)
ren.ResetCameraClippingRange()

# Render and start vis interactivity
render_widget.Render()
iact = render_widget.GetRenderWindow().GetInteractor()
iact.Initialize()
iact.Start()

# Start GUI interactivity
root.mainloop()



