all: diffusion

diffusion: diffusion.lyx
			/Applications/LyX.app/Contents/MacOS/lyx --export xetex diffusion.lyx
			xelatex diffusion
			xelatex diffusion
			rm -f *.aux *.bbl *.blg *.log *.nlo *.tex *.ilg *.nls
			open -a "/Applications/Adobe Acrobat Reader DC.app" diffusion.pdf
