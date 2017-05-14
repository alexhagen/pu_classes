#!/usr/bin/env python

# See PDF Writeup (CS_530_HMWK_2.pdf) for details

# Import needed modules:  vtk for visualization,
# sys for writing files, tkinter for gui
import vtk
import sys
import os
import Tkinter
from vtk.tk.vtkTkRenderWindowInteractor import \
     vtkTkRenderWindowInteractor
from vtk.util.misc import vtkGetDataRoot
# Set data paths
VTK_DATA_ROOT = vtkGetDataRoot()
HMWK_DATA_ROOT = "./"

# Read in datafile specified in program call, open as .vtk.
filename = sys.argv[1]
reader = vtk.vtkDataSetReader()
reader.SetFileName(HMWK_DATA_ROOT + "/" + filename)
reader.Update()
data_range=reader.GetOutput().GetScalarRange()

# Create a contour from the warped data
contour = vtk.vtkContourFilter()
contour.SetInputConnection(reader.GetOutputPort())
contour.SetNumberOfContours(1)
contour.SetValue(0, 48000.)

# Create a mapper
mapper = vtk.vtkDataSetMapper()
mapper.SetInputConnection(contour.GetOutputPort())

# Create an actor from the mapper
actor2 = vtk.vtkActor()
actor2.SetMapper(mapper)

# Create renderer
ren = vtk.vtkRenderer()
renWin = vtk.vtkRenderWindow()
renWin.AddRenderer(ren)
ren.SetBackground(1.0,1.0,1.0)
ren.AddActor(actor2)

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

# Define a scale method to set the scale
def set_val(val):
    global contour, scale_slider
    val_dec = float(val)
    contour.SetValue(0,val_dec)
    ren.ResetCameraClippingRange()
    renWin.Render()
    scale_slider.set(val)

# Render a large image and place in a png
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
    nametofile=filename+"_inner_iso"
    os.system("sleep 1")
    os.system("scrot -u -z -b "+nametofile+".png")
    RenderImage(nametofile+"_big.png")

# Create and add buttons to the gui
cmap=Tkinter.IntVar()
val_low = Tkinter.DoubleVar()
val_low.set(data_range[0])
val_high = Tkinter.DoubleVar()
val_high.set(data_range[1])
val = Tkinter.DoubleVar()
val.set(48000.)
scale_slider = Tkinter.Scale(top, from_=data_range[0], to=data_range[1],
		      orient="horizontal",
                      variable=val,command=set_val,
                      label="Contour Density",resolution=0.01)
scale_slider.pack(fill="x", expand="true")
ctrl_buttons = Tkinter.Frame(top)
ctrl_buttons.pack(side="bottom", anchor="n", fill="both", expand="false")
capture_button = Tkinter.Button(ctrl_buttons, text="Export Magnified Image to File",
                                command=CaptureImage)
capture_button.pack(side="left",fill="x",expand="true")
quit_button = Tkinter.Button(ctrl_buttons, text="Click Here to Quit", command=quit)
quit_button.pack(side="left",expand="true", fill="x")

# Create a view, parallel projection so no perspective
cam1 = ren.GetActiveCamera()
cam1.ParallelProjectionOn()
cam1.Elevation(240)
cam1.SetViewUp(0, 1, 0)
cam1.Azimuth(30)
cam1.Roll(-30)
cam1.Zoom(1.1)
ren.ResetCameraClippingRange()

# Render and start vis interactivity
render_widget.Render()
iact = render_widget.GetRenderWindow().GetInteractor()
iact.Initialize()
iact.Start()

# Start GUI interactivity
root.mainloop()


