/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//   Myosoft: A novel tool to analyze muscle fiber morphometry and type
//   (C) 2019  Lucas Encarnacion-Rivera
//
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License.
// 
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
// 
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <https://www.gnu.org/licenses/>.
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  
// Myosoft
// 
//
//
// Author: Lucas Encarnacion-Rivera 
// Contact: lencriv@stanford.edu
//
// Features:
// --Fiber morphometry 
// --Fiber typing
//
// Citations 
// This program uses code from BAR and Biovoxxel update sites 
// BAR:  DOI 10.5281/zenodo.597784
// Biovoxxel: http://www.biovoxxel.de/

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//----------------------------Get Directories------------------------------------
// this module is where the directories for all files are made 
waitForUser("choose file location of primary classifier")
prim_class_loc = getDirectory("choose file location of primary classifier");
waitForUser("choose file location of iterative classifier")
it_class_loc = getDirectory("choose file location of iterative classifier");
waitForUser("choose place to save single channel images")
chnl_img = getDirectory("choose place to save single channel images");
waitForUser("choose place to save convolved images")
cnv = getDirectory("choose place to save convolved images");
waitForUser("choose place to save segmented images")
prm__seg = getDirectory("choose place to save segmented images")
waitForUser("choose place to save iteratively segmented images")
it__seg = getDirectory("choose place to save iteratively segmented images");
waitForUser("choose place to save fused images")
fused_img = getDirectory("choose place to save fused images images");
waitForUser("choose place to save fiber type and morphometry data")
dat_loc = getDirectory("choose place to save fiber type and morphometry data");
waitForUser("choose place to save ROIs")
roi_loc = getDirectory("choose place to save ROIs");

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//----------------------------Set morphometry gates------------------------------------
// this module is where the morphometric gates are set and are set as vvariables 
// to apply in teh particle analysis program later on

Dialog.create("Morphometric Gates");
Dialog.addMessage ("Morphometric Gates");

Dialog.addNumber("Min Area", 50);
Dialog.addNumber("Max Area", 6000);

Dialog.addMessage ("\n");
Dialog.addNumber("Min Circularity", 0.3);
Dialog.addNumber("Max Circularity", 1);

Dialog.addMessage ("\n");
Dialog.addNumber("Min solidity", 0.75);
Dialog.addNumber("Max solidity", 1);

Dialog.addMessage ("\n");
Dialog.addNumber("Min perimeter", 50);
Dialog.addNumber("Max perimeter", 500);

Dialog.addMessage ("\n");
Dialog.addNumber("Min min Feret", 5.5);
Dialog.addNumber("Max min Feret", 60);

Dialog.addMessage ("\n");
Dialog.addNumber("Min Feret AR", 1);
Dialog.addNumber("Max Feret AR", 4);

Dialog.addMessage ("\n");
Dialog.addNumber("Min roundess", 0.15);
Dialog.addNumber("Max roundess", 1);


Dialog.show();

minAr = Dialog.getNumber();
maxAr = Dialog.getNumber();

minCir = Dialog.getNumber(); 
maxCir = Dialog.getNumber();

minSol = Dialog.getNumber(); 
maxSol = Dialog.getNumber();

minPer = Dialog.getNumber(); 
maxPer = Dialog.getNumber();

minMinFer = Dialog.getNumber(); 
maxMinFer = Dialog.getNumber();

minFAR = Dialog.getNumber(); 
maxFAR = Dialog.getNumber();

minRnd = Dialog.getNumber(); 
maxRnd = Dialog.getNumber();

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//----------------------------Set morphometry gates------------------------------------
// this module is where the ROI expansion factor is set. larger numbers increase degree 
// or enlargement. negative numbers shrink the ROI 

Dialog.create("ROI Expansion");
Dialog.addMessage ("ROI Expansion");

Dialog.addNumber("ROI expansion factor", 4);

Dialog.show();

elrg = Dialog.getNumber();

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//----------------------------Set morphometry gates------------------------------------
// this module is where the ROI expansion factor is set. larger numbers increase degree 
// or enlargement. negative numbers shrink the ROI 

Dialog.create("Set scale");
Dialog.addMessage ("set scale for your image as pixels:microns");

Dialog.addNumber("pixels", 1);
Dialog.addNumber("microns", 1.1);

Dialog.show();

pix = Dialog.getNumber();
mic = Dialog.getNumber();

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//----------------------------color coder information------------------------------------
// this module is where the color coder information is input

cc_choice = newArray("[Red Hot]", "Fire", "[Orange Hot]", "physics") 

Dialog.create("Color Code info");
Dialog.addMessage ("input the maximum and minimum values used to establish the gradiaent for the color coder, color theme, and opacity of the overlay")
Dialog.addNumber("minimum value", 50);
Dialog.addSlider("Opacity", 1, 100, 80);
Dialog.addNumber("Maximum value", 4000);
Dialog.addChoice("Color Code", cc_choice);

Dialog.show();

min_cc = Dialog.getNumber();
opacity = Dialog.getNumber();
max_cc = Dialog.getNumber();
color_code = Dialog.getChoice();

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//----------------------------Set Channel Image Order------------------------------------
// this module is where the image order for the hyperstack is set 

Dialog.create("Hyperstack Order");
Dialog.addMessage ("Put the number corresponding to the position (from left to right) of the channel in the hyperstack (e.g. if it is in the second position, put 2)");

Dialog.addNumber("Membrane", 1);
Dialog.addNumber("Type IIa", 2);
Dialog.addNumber("Type I", 3);
Dialog.addNumber("Type IIb", 4);

Dialog.show();

membrane = Dialog.getNumber();
typeIIa = Dialog.getNumber();
typeI = Dialog.getNumber();
typeIIb = Dialog.getNumber();

////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//-----------------------Channel color adjustment and separation -----------------------------
// This module takes a hyperstack of the channel images and segments the into individual images, saves them to their respective directory,
// and primes the membrane stain for preprocessing 

myoT = getTitle()
myoD = getDirectory("image")
saveAs("Tiff", myoD + myoT)
myoTN = getTitle()

rename("Myosoft-1 one.tif")  

selectWindow("Myosoft-1 one.tif");
run("Duplicate...", "duplicate channels="+membrane+"");
run("Color Balance...");
run("Enhance Contrast", "saturated=0.35");
run("Apply LUT");
saveAs("Tiff", chnl_img + "Myosoft-1 membrane");


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// -------------------------------------------Image Preprocessing ---------------------------------------------------
// this module performs simple color transformation and an image convolution 
// 1) ensure that this is performed on the membrane stain 
// 2) ensure that the image convolution yeilds clearly defined edges 

run("Enhance Contrast", "saturated=1");
run("8-bit");
run("8-bit");
run("Invert");
run("Convolve...", "text1=[-1.0 -1.0 -1.0 -1.0 -1.0\n-1.0 -1.0 -1.0 -1.0 0\n-1.0 -1.0 24.0 -1.0 -1.0\n-1.0 -1.0 -1.0 -1.0 -1.0\n-1.0 -1.0 -1.0 -1.0 0] normalize");

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--------------------------------Image Segmentation-----------------------------------------
// this module takes the entire convolved image from preproscessing, segments it into 16 images
// and segments it into 
// 1) a GUI will prompt you to choose the number of divisions you want --> select 4 and press ok
run("Set Scale...", "distance="+pix+" known="+mic+" pixel=1 unit=micron"); 

n_div = getNumber("How many divisions (e.g., 2 means quarters)?", 4); 
id = getImageID(); 
title = getTitle(); 
getLocationAndSize(locX, locY, sizeW, sizeH); 
width = getWidth(); 
height = getHeight(); 
tileWidth = width / n_div; 
tileHeight = height / n_div; 
for (y = 0; y < n_div; y++) { 
offsetY = y * height / n_div; 
 for (x = 0; x < n_div; x++) { 
offsetX = x * width / n_div; 
selectImage(id); 
 call("ij.gui.ImageWindow.setNextLocation", locX + offsetX, locY + offsetY); 
tileTitle = title + " [" + x + "," + y + "]"; 
 run("Duplicate...", "title=" + tileTitle); 
makeRectangle(offsetX, offsetY, tileWidth, tileHeight); 
 run("Crop"); 
}  
} 

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--------------------------------Segmented images saving------------------------------------
// This modules selects all segmented images and saves them to their respective directory

if (n_div==1) {
	selectWindow("Myosoft-1 membrane.tif"); 
	close();
	selectWindow("Myosoft-1 one.tif"); 
	close();
	selectWindow("Myosoft-1"); 
	saveAs(cnv + "Myosoft-1");
	close();

}

if (n_div==2) {
	selectWindow("Myosoft-1 membrane.tif"); 
	close();
	selectWindow("Myosoft-1 one.tif"); 
	close();
	selectWindow("Myosoft-1"); 
	saveAs(cnv + "Myosoft-1");
	close();
		       
	for(i=0; i<3; i++)
		  if (isOpen("Myosoft-1")) { 
		      selectWindow("Myosoft-1"); 
		      run("Duplicate...", "duplicate channels= 1");
		      selectWindow("Myosoft-1"); 
		      close();
		   } 
		 
	cnv_open=newArray(nImages); 
	for (i=0;i<nImages;i++) { 
		       selectImage(i+1); 
		       title = getTitle; 
		       print(title); 
		       cnv_open[i]=getImageID; 
		       saveAs("tiff", cnv+title);
		       
	}}

if (n_div==3) {
	selectWindow("Myosoft-1 membrane.tif"); 
	close();
	selectWindow("Myosoft-1 one.tif"); 
	close();
	selectWindow("Myosoft-1"); 
	saveAs(cnv + "Myosoft-1");
	close();
		       
	for(i=0; i<8; i++)
		  if (isOpen("Myosoft-1")) { 
		      selectWindow("Myosoft-1"); 
		      run("Duplicate...", "duplicate channels= 1");
		      selectWindow("Myosoft-1"); 
		      close();
		   } 
		 
	cnv_open=newArray(nImages); 
	for (i=0;i<nImages;i++) { 
		       selectImage(i+1); 
		       title = getTitle; 
		       print(title); 
		       cnv_open[i]=getImageID; 
		       saveAs("tiff", cnv+title);
		       
	}}

if (n_div==4) {
	selectWindow("Myosoft-1 membrane.tif"); 
	close();
	selectWindow("Myosoft-1 one.tif"); 
	close();
	selectWindow("Myosoft-1"); 
	saveAs(cnv + "Myosoft-1");
	close();
		       
	for(i=0; i<15; i++)
		  if (isOpen("Myosoft-1")) { 
		      selectWindow("Myosoft-1"); 
		      run("Duplicate...", "duplicate channels= 1");
		      selectWindow("Myosoft-1"); 
		      close();
		   } 
		 
	cnv_open=newArray(nImages); 
	for (i=0;i<nImages;i++) { 
		       selectImage(i+1); 
		       title = getTitle; 
		       print(title); 
		       cnv_open[i]=getImageID; 
		       saveAs("tiff", cnv+title);
		       
	}}
	        
if (n_div==5) {
	selectWindow("Myosoft-1 membrane.tif"); 
	close();
	selectWindow("Myosoft-1 one.tif"); 
	close();
	selectWindow("Myosoft-1"); 
	saveAs(cnv + "Myosoft-1");
	close();
		       
	for(i=0; i<24; i++)
		  if (isOpen("Myosoft-1")) { 
		      selectWindow("Myosoft-1"); 
		      run("Duplicate...", "duplicate channels= 1");
		      selectWindow("Myosoft-1"); 
		      close();
		   } 
		 
	cnv_open=newArray(nImages); 
	for (i=0;i<nImages;i++) { 
		       selectImage(i+1); 
		       title = getTitle; 
		       print(title); 
		       cnv_open[i]=getImageID; 
		       saveAs("tiff", cnv+title);
		       
	}}

run("Close All");

open(myoD+myoTN);
rename("Myosoft-1 one");  

run("Color Balance...");
run("Duplicate...", "duplicate channels="+typeI+"");
run("Color Balance...");
run("Enhance Contrast", "saturated=0.35");
run("Apply LUT");
saveAs("Tiff", chnl_img + "Myosoft-1 typeI");

selectWindow("Myosoft-1 one");
run("Duplicate...", "duplicate channels="+typeIIa+"");
run("Color Balance...");
run("Enhance Contrast", "saturated=0.35");
run("Apply LUT");
saveAs("Tiff", chnl_img + "Myosoft-1 typeIIa");
close();

selectWindow("Myosoft-1 one");
run("Duplicate...", "duplicate channels="+typeIIb+"");
run("Color Balance...");
run("Enhance Contrast", "saturated=0.35");
run("Apply LUT");
saveAs("Tiff", chnl_img + "Myosoft-1 typeIIb");

run("Trainable Weka Segmentation");
wait(2000);
TWS=getTitle();

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------Primary segmentation--------------------------------------
//this module loads the trainable weka semgentor plugin, calls the machine learning classifier 
// from its respecive directory location and applies it to all segmented convolved images from
// the previous module and saves it to it's respective directory

selectWindow(""+TWS+"");
call("trainableSegmentation.Weka_Segmentation.loadClassifier", prim_class_loc + "simple fiber outline classifier.model");
call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-1.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
wait(10);
selectWindow("Classification result");
run("Delete Slice");
saveAs("Tiff", prm__seg + "Myosoft-1");
close();
close();

if (n_div>=2) {
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-2.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-2");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-3.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-3");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-4.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-4");
	close();
	close();

}

if (n_div>=3) {

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-5.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-5");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-6.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-6");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-7.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-7");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-8.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-8");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-9.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-9");
	close();
	close();
}

if (n_div>=4) {

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-10.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-10");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-11.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "")
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-11");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-12.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-12");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-13.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-13");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-14.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-14");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-15.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-15");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-16.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-16");
	close();
	close();

}

if (n_div==5) {
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-17.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-17");
	close();
	close();

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-18.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-18");
	close();
	close();

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-19.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-19");
	close();
	close();

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-20.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-20");
	close();
	close();

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-21.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-21");
	close();
	close();

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-22.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-22");
	close();
	close();

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-23.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-23");
	close();
	close();

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-24.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-24");
	close();
	close();

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", cnv, "Myosoft-25.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", prm__seg + "Myosoft-25");
	close();
	close();
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------Iterative segmentation----------------------------------------------------
//this module loads the trainable weka semgentor plugin, calls the iterative machine learning classifier 
// from its respecive directory location and applies it to all segmented convolved images from
// the previous module and saves it to it's respective directory

selectWindow(""+TWS+"");
call("trainableSegmentation.Weka_Segmentation.loadClassifier", it_class_loc + "iterative fiber classifier.model");
call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-1.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
wait(10);
selectWindow("Classification result");
run("Delete Slice");
saveAs("Tiff", it__seg + "Myosoft-1");
close();
close();

if (n_div>=2) {

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-2.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-2");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-3.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-3"); 
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-4.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-4");
	close();
	close();
}

if (n_div>=3) {
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-5.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-5");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-6.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-6");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-7.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-7");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-8.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-8");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-9.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-9");
	close();
	close();
}

if (n_div>=4) {

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-10.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-10");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-11.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "")
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-11");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-12.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-12");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-13.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-13");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-14.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-14");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-15.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-15");
	close();
	close();
	
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-16.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-16");
	close();
	close();

}

if (n_div==5) {
	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-17.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-17");
	close();
	close();

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-18.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-18");
	close();
	close();

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-19.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-19");
	close();
	close();

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-20.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-20");
	close();
	close();

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-21.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-21");
	close();
	close();

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-22.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-22");
	close();
	close();

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-23.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-23");
	close();
	close();

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-24.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-24");
	close();
	close();

	selectWindow(""+TWS+"");
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", prm__seg, "Myosoft-25.tif", "showResults=true", "storeResults=false", "probabilityMaps=true", "");
	selectWindow("Classification result");
	run("Delete Slice");
	saveAs("Tiff", it__seg + "Myosoft-25");
	close();
	close();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------Image Stitching-----------------------------------------------------
//this module calls all iteratively segmented images and recombines them to form a single and segmented 
// image of the muscle section. Then it saves this image as a dummy file name to a respective location, 
// closes all open files and calls the stiched image 
if(n_div>1) {
	run("Grid/Collection stitching", "type=[Grid: row-by-row] order=[Right & Down                ] grid_size_x="+n_div+" grid_size_y="+n_div+" tile_overlap=0 first_file_index_i=1 directory=["+it__seg+"] file_names=Myosoft-{i}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 computation_parameters=[Save memory (but be slower)] image_output=[Fuse and display] use");
	selectWindow("Fused");
	run("8-bit");
	saveAs("Tiff", fused_img + myoT + "_segmented.tif"); 
	run("Close All");
	open(fused_img + myoT + "_segmented.tif");
}
if(n_div==1){
	open(it__seg + "Myosoft-1.tif");
	saveAs("Tiff", fused_img + myoT + "_segmented.tif"); 
	run("Close All");
	open(fused_img + myoT + "_segmented.tif");
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------Set measurements-------------------------------------------------------
//this module interpolates subpizel resolution, sets the scale for the image, and the measurmements to be collected 

run("Plots...", "width=530 height=300 font=12 draw draw_ticks minimum=-50 maximum=-50 interpolate sub-pixel");
run("Set Scale...", "distance="+pix+" known="+mic+" pixel=1 unit=micron"); // the known distance and units may change based on image
// you can change these by simply plugging in different values for the known distance or for the unit. 
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding shape feret's median redirect=None decimal=4");

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-----------------------------------Particle Analysis--------------------------------------------------------------
//this module edits the iteratively segmented image of the muscle section, binarizes it, runs it through 
// a watershed algorithm, and then extracts all white pizel values as objects and represents them as ROIs 
// on the ROI manager 

run("Median...", "radius=2"); // the radius can be changed by putting in different numbers
run("Gaussian Blur...", "sigma=2"); // the sigma can be changed by putting in different numbers
setAutoThreshold("MaxEntropy");
run("Create Mask");
run("Invert");
run("Watershed Irregular Features", "erosion=1 convexity_threshold=1 separator_size=2-15"); 
//^^ the degree of segmentation by the watershed can be adjusted in the "separator_size:..." component 
//^^ the higher the number, the greater the segmentation 
setForegroundColor(255,255,255);
drawRect(0, 0, getWidth(), getHeight());
run("Extended Particle Analyzer", "pixel area="+minAr+"-"+maxAr+" min_feret="+minMinFer+"-"+maxMinFer+" perimeter="+minPer+"-"+maxPer+" feret_ar="+minFAR+"-"+maxFAR+" circularity="+minCir+"-"+maxCir+" roundness="+minRnd+"-"+maxRnd+" solidity="+minSol+"-"+maxSol+" show=Outlines redirect=None keep=None display summarize add");

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-----------------------------------ROI Expansion--------------------------------------------------------------
//this module selects all ROIs and expands them by a factor of 'X' as new ROIs and deletes previous ROIs 
roiManager("Save", roi_loc+"total_smallROI.zip");
n_total = roiManager("count");

ROIArr = newArray("0");; 
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);

nbFibers=roiManager("count");
if (nbFibers > 0) {
		selectWindow("ROI Manager");
		for (i=0 ; i<nbFibers; i++) {
		    roiManager("select", i);
    		run("Enlarge...", "enlarge="+elrg+""); 
    		roiManager("Add")				
		}
}
roiManager("Delete");
roiManager("Save", roi_loc+"total_ROI.zip");

 if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
   } 
   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 

   
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-----------------------------------Fiber Typing--------------------------------------------------------------
//this module edits retrieves channel images from the first module and overlays the ROIs as a mask and measures
// values to obtain mean intensity. dat_loc and reference/ index images are saved to a location on the computer
open(chnl_img + "Myosoft-1 typeIIa.tif");
run("Set Scale...", "distance="+pix+" known="+mic+" pixel=1 unit=micron"); 

roiManager("Open", roi_loc+"total_smallROI.zip");

roiManager("Show All with labels");
roiManager("Measure");

run("Distribution...", "parameter=Mean automatic");
waitForUser("Determine IIa intensity gate");

selectWindow("Myosoft-1 typeIIa.tif");
   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
roiManager("Open", roi_loc+"total_ROI.zip");

Dialog.create("Fiber Type Gates IIa");
Dialog.addMessage ("Fiber Type Gates IIa");
Dialog.addNumber("Type IIa Gate", 300);
Dialog.show();
IIaGt = Dialog.getNumber();

ROIArr = newArray("0");; 
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
n=roiManager("count");

		for (i=0;i<n;i++){
			roiManager("select",i);
			Mean = getResult("Mean",i);
			if((IIaGt<Mean)){
				roiManager("select", i); 
				roiManager("Add", i);
				};
		};

roiManager("Delete");
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   }; 


n_IIa=roiManager("count");
if (n_IIa>0) {
			roiManager("Save", roi_loc+"IIa_ROI.zip")
    		

newImage("Untitled", "8-bit white", width, height, 1);

roiManager("Show All without labels");

ROIArr = newArray("0");
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
roiManager("Set Fill Color", "black");

run("Flatten");
saveAs("Tiff", roi_loc + "BW_referenceImg_typeIIa");

   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
};
		
else {
	print("No IIa fibers found");
};

   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   };
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
open(chnl_img + "Myosoft-1 typeIIb.tif");
run("Set Scale...", "distance="+pix+" known="+mic+" pixel=1 unit=micron"); 


   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 

roiManager("Open", roi_loc+"total_smallROI.zip");

roiManager("Show All with labels");
//
roiManager("Measure");

run("Distribution...", "parameter=Mean automatic");
waitForUser("Determine IIb intensity gate");

selectWindow("Myosoft-1 typeIIb.tif");
   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
roiManager("Open", roi_loc+"total_ROI.zip");

Dialog.create("Fiber Type Gates IIb");
Dialog.addMessage ("Fiber Type Gates IIb");
Dialog.addNumber("Type IIb Gate", 300);
Dialog.show();
IIbGt = Dialog.getNumber();

ROIArr = newArray("0");; 
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
n=roiManager("count");

		for (i=0;i<n;i++){
			roiManager("select",i);
			Mean = getResult("Mean",i);
			if((IIbGt<Mean)){
				roiManager("select", i); 
				roiManager("Add", i);
				};
		};

roiManager("Delete");
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 

n_IIb=roiManager("count");
if (n_IIb>0) {
			roiManager("Save", roi_loc+"IIb_ROI.zip")
    		

newImage("Untitled", "8-bit white", width, height, 1);

roiManager("Show All without labels");

ROIArr = newArray("0");
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
roiManager("Set Fill Color", "black");

run("Flatten");
saveAs("Tiff", roi_loc + "BW_referenceImg_typeIIb");

   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
};
		
else {
	print("No IIb fibers found");
};

   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   };
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

open(chnl_img + "Myosoft-1 typeI.tif");
run("Set Scale...", "distance="+pix+" known="+mic+" pixel=1 unit=micron"); 

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   
roiManager("Open", roi_loc+"total_ROI.zip");

roiManager("Show All with labels");
//
roiManager("Measure");


run("Distribution...", "parameter=Mean automatic");
waitForUser("Determine I intensity gate");

selectWindow("Myosoft-1 typeI.tif");
   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
roiManager("Open", roi_loc+"total_ROI.zip");

Dialog.create("Fiber Type Gates I");
Dialog.addMessage ("Fiber Type Gates I");
Dialog.addNumber("Type I Gate", 300);
Dialog.show();
IGt = Dialog.getNumber();

ROIArr = newArray("0");; 
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
n=roiManager("count");

		for (i=0;i<n;i++){
			roiManager("select",i);
			Mean = getResult("Mean",i);
			if((IGt<Mean)){
				roiManager("select", i); 
				roiManager("Add", i);
				};
			};
roiManager("Delete");
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 

n_I=roiManager("count");
if (n_I>0) {
			roiManager("Save", roi_loc+"I_ROI.zip")
    		
newImage("Untitled", "8-bit white", width, height, 1);

roiManager("Show All without labels");

ROIArr = newArray("0");; 
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
roiManager("Set Fill Color", "black");

run("Flatten");
saveAs("Tiff", roi_loc + "BW_referenceImg_typeI");

   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
};

else {
	print("No Type I fibers found");
};
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   };

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

run("Close All");

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
if(n_IIa>0) {
open(roi_loc + "BW_referenceImg_typeIIa.tif");
if(n_IIb>0) {
roiManager("Open", roi_loc+"IIb_ROI.zip");
roiManager("Show All with labels");
//
roiManager("Measure");

ROIArr = newArray("0");; 
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
n=roiManager("count");

		for (i=0;i<n;i++){
			roiManager("select",i);
			Mode = getResult("Mode",i);
			if((0==Mode)){
				roiManager("select", i); 
				roiManager("Add", i);
			};
		};

roiManager("Delete");

   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
}
};   
n_IIa_IIb=roiManager("count");
if (n_IIa_IIb>0) {
			roiManager("Save", roi_loc+"IIa_IIb_ROI.zip")
};
else {
	print("No IIb and IIa fibers found");
};

   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   };

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
if(n_IIa>0) {
open(roi_loc + "BW_referenceImg_typeIIa.tif");
if(n_I>0) {
roiManager("Open", roi_loc+"I_ROI.zip");
roiManager("Show All with labels");
//
roiManager("Measure");

ROIArr = newArray("0");; 
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
n=roiManager("count");

		for (i=0;i<n;i++){
			roiManager("select",i);
			Mode = getResult("Mode",i);
			if((0==Mode)){
				roiManager("select", i); 
				roiManager("Add", i);
			};
		};

roiManager("Delete");

   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
}
};
n_IIa_I=roiManager("count");
if (n_IIa_I>0) {
		  		roiManager("Save", roi_loc+"IIa_I_ROI.zip")
    					
		};

else {
	print("No I and IIa fibers found");
};
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   };

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
if(n_I>0) {   
open(roi_loc + "BW_referenceImg_typeI.tif");
if(n_IIb>0) {
roiManager("Open", roi_loc+"IIb_ROI.zip");
roiManager("Show All with labels");
//
roiManager("Measure");

ROIArr = newArray("0");
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
n=roiManager("count");

		for (i=0;i<n;i++){
			roiManager("select",i);
			Mode = getResult("Mode",i);
			if((0==Mode)){
				roiManager("select", i); 
				roiManager("Add", i);
			};
		};
roiManager("Delete");

   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
};
};

n_I_IIb=roiManager("count");
if (n_I_IIb>0) {
			roiManager("Save", roi_loc+"I_IIb_ROI.zip")
   		};

else {
	print("No I and IIb fibers found");
};
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   };

//////////////////////////////////////////////////////////////////////////////////////////////////////////////


   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
      if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
   if(n_I_IIb>0) {
roiManager("Open", roi_loc+"I_IIb_ROI.zip");
   
newImage("Untitled", "8-bit white", width, height, 1);

roiManager("Show All without labels");

ROIArr = newArray("0");; 
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
roiManager("Set Fill Color", "black");
run("Flatten");

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   };
   
if(n_IIa>0) {
roiManager("Open", roi_loc+"IIa_ROI.zip");
roiManager("Show All without labels");
//
roiManager("measure")

ROIArr = newArray("0"); 
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
n=roiManager("count");

		for (i=0;i<n;i++){
			roiManager("select",i);
			Mode = getResult("Mode",i);
			if((0==Mode)){
				roiManager("select", i); 
				roiManager("Add", i);
			};
		};
roiManager("Delete");
  
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
}
};   
n_I_IIb_IIa=roiManager("count");
if (n_I_IIb_IIa>0) {
	  		roiManager("Save", roi_loc+"I_IIb_IIa_ROI.zip")
    		};

else {
	print("No I IIb and IIa fibers found");
};
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   };
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
   if(n_I_IIb>0) {
roiManager("Open", roi_loc+"I_IIb_ROI.zip");
   }
   if(n_IIa_IIb>0) {
roiManager("Open", roi_loc+"IIa_IIb_ROI.zip");
   }
   if(n_I_IIb_IIa>0) {
roiManager("Open", roi_loc+"I_IIb_IIa_ROI.zip");
   };

n_IImixed=roiManager("count");
if(n_IImixed>0) {
newImage("Untitled", "8-bit white", width, height, 1);
roiManager("Show All without labels");

ROIArr = newArray("0"); 
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
roiManager("Set Fill Color", "black");
run("Flatten");

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 

if(n_IIb>0) {
roiManager("Open", roi_loc+"IIb_ROI.zip");
//
roiManager("measure"); 

ROIArr = newArray("0"); 
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
n=roiManager("count");

		for (i=0;i<n;i++){
			roiManager("select",i);
			Mode = getResult("Mode",i);
			if((255==Mode)){
				roiManager("select", i); 
				roiManager("Add", i);
			};
		};
roiManager("Delete");
 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
}; 
};
else{
	if(n_IIb>0) {
	 roiManager("Open", roi_loc+"IIb_ROI.zip");
}
};

n_IIb_only=roiManager("count");
if (n_IIb_only>0) {
	   		roiManager("Save", roi_loc+"IIb_only_ROI.zip")
    		};

else {
	print("No IIb only fibers found");
};
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   };
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
   if(n_I_IIb>0) {
roiManager("Open", roi_loc+"I_IIb_ROI.zip");
   }
   if(n_IIa_I>0) {
roiManager("Open", roi_loc+"IIa_I_ROI.zip");
   }
   if(n_I_IIb_IIa>0) {
roiManager("Open", roi_loc+"I_IIb_IIa_ROI.zip");
   };

n_Imixed=roiManager("count");
if(n_Imixed>0) {
newImage("Untitled", "8-bit white", width, height, 1);
roiManager("Show All without labels");

ROIArr = newArray("0");
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
roiManager("Set Fill Color", "black");
run("Flatten");

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
if(n_I>0) {
roiManager("Open", roi_loc+"I_ROI.zip");
roiManager("Show All without labels");
//
roiManager("measure"); 
};

ROIArr = newArray("0"); 
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
n=roiManager("count");

		for (i=0;i<n;i++){
			roiManager("select",i);
			Mode = getResult("Mode",i);
			if((255==Mode)){
				roiManager("select", i); 
				roiManager("Add", i);
			};
		};
roiManager("Delete");
 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
};

else{
	if(n_I>0) {
roiManager("Open", roi_loc+"I_ROI.zip");
		
	};
};

n_I_only=roiManager("count");
if (n_I_only>0) {
	   		roiManager("Save", roi_loc+"I_only_ROI.zip")
    		};

else {
	print("No I only fibers found");
};
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   };
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
   if(n_IIa_IIb>0) {
roiManager("Open", roi_loc+"IIa_IIb_ROI.zip");
   }
   if(n_IIa_I>0) {
roiManager("Open", roi_loc+"IIa_I_ROI.zip");
   }
   if(n_I_IIb_IIa>0) {
roiManager("Open", roi_loc+"I_IIb_IIa_ROI.zip");
   };

n_IIamixed=roiManager("count");
if(n_IIamixed>0) {
newImage("Untitled", "8-bit white", width, height, 1);
roiManager("Show All without labels");

ROIArr = newArray("0");; 
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
roiManager("Set Fill Color", "black");
run("Flatten");

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 

if(n_IIa>0) {   
roiManager("Open", roi_loc+"IIa_ROI.zip");
//
roiManager("measure"); 

ROIArr = newArray("0"); 
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
n=roiManager("count");

		for (i=0;i<n;i++){
			roiManager("select",i);
			Mode = getResult("Mode",i);
			if((255==Mode)){
				roiManager("select", i); 
				roiManager("Add", i);
			};
		};
roiManager("Delete");
 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
};
};
else{
	if (n_IIa>0) {   
roiManager("Open", roi_loc+"IIa_ROI.zip");
}
};

n_IIa_only=roiManager("count");
if (n_IIa_only>0) {
	roiManager("Save", roi_loc+"IIa_only_ROI.zip")
    	};

else {
	print("No IIa only fibers found");
};
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   };
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
if(n_IIa>0) {
roiManager("Open", roi_loc+"IIa_ROI.zip");
}
if(n_I>0) {
roiManager("Open", roi_loc+"I_ROI.zip");
}
if(n_IIb>0) {
roiManager("Open", roi_loc+"IIb_ROI.zip");
}

newImage("Untitled", "8-bit white", width, height, 1);
roiManager("Show All without labels");

ROIArr = newArray("0");; 
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
roiManager("Set Fill Color", "black");
run("Flatten");

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
roiManager("Open", roi_loc+"total_ROI.zip");
roiManager("Show All without labels");
//
roiManager("measure"); 

ROIArr = newArray("0"); 
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
n=roiManager("count");

		for (i=0;i<n;i++){
			roiManager("select",i);
			Mode = getResult("Mode",i);
			if((255==Mode)){
				roiManager("select", i); 
				roiManager("Add", i);
			};
		};
roiManager("Delete");
 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close");
   } 
run("Close All");   

n_IIx_only=roiManager("count");
if (n_IIx_only>0) {
	for (i=0 ; i<n_IIx_only; i++) {
  		roiManager("Save", roi_loc+"IIx_only_ROI.zip")
    	};
};
else {
	print("No IIx only fibers found");
};
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

if (n_I_IIb_IIa>0) {

roiManager("Open", roi_loc+"I_IIb_IIa_ROI.zip");
newImage("Untitled", "8-bit white", width, height, 1);
roiManager("Show All without labels");

ROIArr = newArray("0");
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
roiManager("Set Fill Color", "black");

run("Flatten");

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
   
 if(n_I_IIb>0) {
roiManager("Open", roi_loc+"I_IIb_ROI.zip");
roiManager("measure"); 

ROIArr = newArray("0");
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
n=roiManager("count");

		for (i=0;i<n;i++){
			roiManager("select",i);
			Mode = getResult("Mode",i);
			if((255==Mode)){
				roiManager("select", i); 
				roiManager("Add", i);
			};
		};
roiManager("Delete");
roiManager("Save", roi_loc+"I_IIb_ROI.zip")
   }
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
   
 if(n_IIa_I>0) {
roiManager("Open", roi_loc+"IIa_I_ROI.zip");
roiManager("measure"); 

ROIArr = newArray("0");
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
n=roiManager("count");

		for (i=0;i<n;i++){
			roiManager("select",i);
			Mode = getResult("Mode",i);
			if((255==Mode)){
				roiManager("select", i); 
				roiManager("Add", i);
			};
		};
roiManager("Delete");
roiManager("Save", roi_loc+"IIa_I_ROI.zip")
   }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
   
 if(n_IIa_IIb>0) {
roiManager("Open", roi_loc+"IIa_IIb_ROI.zip");
roiManager("measure"); 

ROIArr = newArray("0");
for (i=1;i<roiManager("count");i++){ 
        ROIArr = Array.concat(ROIArr,i); 
        Array.print(ROIArr); 
} 
roiManager("select", ROIArr);
n=roiManager("count");

		for (i=0;i<n;i++){
			roiManager("select",i);
			Mode = getResult("Mode",i);
			if((255==Mode)){
				roiManager("select", i); 
				roiManager("Add", i);
			};
		};
roiManager("Delete");
roiManager("Save", roi_loc+"IIa_IIb_ROI.zip")
   }


}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
run("Set Measurements...", "area centroid center perimeter bounding shape feret's median redirect=None decimal=4");

newImage("Untitled", "8-bit white", width, height, 1);
   
   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
if (n_IIa>0) {
roiManager("Open", roi_loc+"IIa_ROI.zip");
roiManager("Measure"); 
run("Summarize"); 
saveAs("Results", dat_loc + "IIa_Results.csv");
}

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
if (n_IIb>0) {
roiManager("Open", roi_loc+"IIb_ROI.zip");
//
roiManager("Measure"); 
run("Summarize"); 
saveAs("Results", dat_loc + "IIb_Results.csv");
}

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
if (n_I>0) {
roiManager("Open", roi_loc+"I_ROI.zip");
//
roiManager("Measure"); 
run("Summarize"); 
saveAs("Results", dat_loc + "I_Results.csv");
}

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   }   
if (n_IIx_only>0) {   
roiManager("Open", roi_loc+"IIx_only_ROI.zip");
//
roiManager("Measure"); 
run("Summarize"); 
saveAs("Results", dat_loc + "IIx_Results.csv");
}
   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
if (n_IIa_only>0) {
roiManager("Open", roi_loc+"IIa_only_ROI.zip");
//
roiManager("Measure"); 
run("Summarize"); 
saveAs("Results", dat_loc + "IIa_only_Results.csv");
}
   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
if (n_IIb_only>0) {
roiManager("Open", roi_loc+"IIb_only_ROI.zip");
//
roiManager("Measure"); 
run("Summarize"); 
saveAs("Results", dat_loc + "IIb_only_Results.csv");
}

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
if (n_I_only>0) {
roiManager("Open", roi_loc+"I_only_ROI.zip");
//
roiManager("Measure"); 
run("Summarize"); 
saveAs("Results", dat_loc + "I_only_Results.csv");
}
   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
if (n_IIa_IIb>0) {
roiManager("Open", roi_loc+"IIa_IIb_ROI.zip");
//
roiManager("Measure"); 
run("Summarize"); 
saveAs("Results", dat_loc + "IIa_IIb_Results.csv");
}

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
if (n_IIa_I>0) {
roiManager("Open", roi_loc+"IIa_I_ROI.zip");
//

roiManager("Measure"); 
run("Summarize"); 
saveAs("Results", dat_loc + "IIa_I_Results.csv");
}

   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
if (n_I_IIb>0) {
roiManager("Open", roi_loc+"I_IIb_ROI.zip");

//
roiManager("Measure"); 
run("Summarize"); 
saveAs("Results", dat_loc + "I_IIb_Results.csv");
}
   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   } 
   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 
if (n_I_IIb_IIa>0) {
roiManager("Open", roi_loc+"I_IIb_IIa_ROI.zip");
//

roiManager("Measure"); 
run("Summarize"); 
saveAs("Results", dat_loc + "I_IIb_IIa_Results.csv");
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
cpmms = n_total/(width*height);
Proportion_IIb = n_IIb/n_total;
Proportion_IIa = n_IIa/n_total;
Proportion_I = n_I/n_total;
Proportion_IIx = n_IIx_only/n_total;

 if (isOpen("Log")) { 
       selectWindow("Log");
       run("Close"); 
   }; 
 
print("µm^2 --- Cells per µm^2: "+cpmms+"µm^2 --- Proportion IIb "+Proportion_IIb+" --- Proportion IIa "+Proportion_IIa+" --- Proportion I "+Proportion_I+" --- Proportion IIx "+Proportion_IIx+"");
selectWindow("Log");
saveAs("Text", dat_loc + "Summary_stats.txt");

///////////////////////////////////////////////////////////////////////////////////////////////////////////////


run("Close All"); 

 if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   }; 
 
   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   };
    
open(chnl_img + "Myosoft-1 membrane.tif");
roiManager("Open", roi_loc+"total_ROI.zip");
run("Set Scale...", "distance="+pix+" known="+mic+" pixel=1 unit=micron"); 
roiManager("Show All with labels");
roiManager("Measure");
run("Flatten");
saveAs("Tiff", dat_loc + "InputImageNameHere_referenceImg_area");
saveAs("Results", dat_loc + "Fiber_area_Results.csv");

selectWindow("Myosoft-1 membrane.tif");
run("ROI Color Coder", "measurement=Area lut="+color_code+" width=0 opacity="+opacity+" label=microns^2 range="+min_cc+"-"+max_cc+" n.=5 decimal=0 ramp=[256 pixels] font=SansSerif font_size=14 draw");

saveAs("Tiff", dat_loc + "color code legend");

selectWindow("Myosoft-1 membrane.tif");
run("Flatten");
saveAs("Tiff", dat_loc + "InputImageNameHere_referenceImg_ColorCode");

   if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
   } 
 
   if (isOpen("ROI Manager")) { 
       selectWindow("ROI Manager");
       run("Close"); 
   };
run("Close All");

waitForUser("Analysis Complete");