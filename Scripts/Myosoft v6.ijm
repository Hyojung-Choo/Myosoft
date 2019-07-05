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
// Contact: lencarn@emory.edu 
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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//----------------------------Set morphometry gates------------------------------------
// this module is where the morphometric gates are set and are set as vvariables 
// to apply in teh particle analysis program later on

Dialog.create("Morphometric Gates");
Dialog.addMessage ("Morphometric Gates");

Dialog.addNumber("Min Area", 300);
Dialog.addNumber("Max Area", 13000);

Dialog.addMessage ("\n");
Dialog.addNumber("Min Circularity", 0.5);
Dialog.addNumber("Max Circularity", 1);

Dialog.addMessage ("\n");
Dialog.addNumber("Min solidity", 0.75);
Dialog.addNumber("Max solidity", 1);

Dialog.addMessage ("\n");
Dialog.addNumber("Min perimeter", 0);
Dialog.addNumber("Max perimeter", 1000);

Dialog.addMessage ("\n");
Dialog.addNumber("Min min ferret", 20);
Dialog.addNumber("Max min ferret", 10000);

Dialog.addMessage ("\n");
Dialog.addNumber("Min ferret AR", 0);
Dialog.addNumber("Max ferret AR", 8);

Dialog.addMessage ("\n");
Dialog.addNumber("Min roundess", 0.2);
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
Dialog.addNumber("microns", 0.9091);

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
Dialog.addNumber("minimum value", 0);
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

n = getNumber("How many divisions (e.g., 2 means quarters)?", 4); 
id = getImageID(); 
title = getTitle(); 
getLocationAndSize(locX, locY, sizeW, sizeH); 
width = getWidth(); 
height = getHeight(); 
tileWidth = width / n; 
tileHeight = height / n; 
for (y = 0; y < n; y++) { 
offsetY = y * height / n; 
 for (x = 0; x < n; x++) { 
offsetX = x * width / n; 
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

if (n==1) {
	selectWindow("Myosoft-1 membrane.tif"); 
	close();
	selectWindow("Myosoft-1 one.tif"); 
	close();
	selectWindow("Myosoft-1"); 
	saveAs(cnv + "Myosoft-1");
	close();

}

if (n==2) {
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

if (n==3) {
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

if (n==4) {
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
	        
if (n==5) {
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
selectWindow("Classification result");
run("Delete Slice");
saveAs("Tiff", prm__seg + "Myosoft-1");
close();
close();

if (n>=2) {
	
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

if (n>=3) {

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

if (n>=4) {

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

if (n==5) {
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
selectWindow("Classification result");
run("Delete Slice");
saveAs("Tiff", it__seg + "Myosoft-1");
close();
close();

if (n>=2) {

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

if (n>=3) {
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

if (n>=4) {

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

if (n==5) {
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

run("Grid/Collection stitching", "type=[Grid: row-by-row] order=[Right & Down                ] grid_size_x="+n+" grid_size_y="+n+" tile_overlap=0 first_file_index_i=1 directory=["+it__seg+"] file_names=Myosoft-{i}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 computation_parameters=[Save memory (but be slower)] image_output=[Fuse and display] use");
selectWindow("Fused");
run("8-bit");
saveAs("Tiff", fused_img + myoT + "_segmented.tif"); // the name of this image will need to change with 
// each code run as it will save over images with the same name. Segmented images will be valuable if analysis 
// is to be reperformed --> all prior steps will not need to be repeated

run("Close All");

open(fused_img + myoT + "_segmented.tif"); // Change this image name so that it is the same as 
// the one above 

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------Set measurements-------------------------------------------------------
//this module interpolates subpizel resolution, sets the scale for the image, and the measurmements to be collected 

run("Plots...", "width=530 height=300 font=12 draw draw_ticks minimum=-50 maximum=-50 interpolate sub-pixel");
run("Set Scale...", "distance="+mic+" known=1 pixel="+pix+" unit=micron"); // the known distance and units may change based on image
// you can change these by simply plugging in different values for the known distance or for the unit. 
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding shape feret's median redirect=None decimal=4");

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-----------------------------------Particle Analysis--------------------------------------------------------------
//this module edits the iteratively segmented image of the muscle section, binarizes it, runs it through 
// a watershed algorithm, and then extracts all white pizel values as objects and represents them as ROIs 
// on the ROI manager 

run("Median...", "radius=3"); // the radius can be changed by putting in different numbers
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
    		run("Enlarge...", "enlarge="+elrg+""); // The number here controls the degree to which the ROIs are 
    		roiManager("Add")				// enlarged. The higher the number, the more they are enlarged 
		}

roiManager("Delete");

 if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
   } 

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-----------------------------------Fiber Typing--------------------------------------------------------------
//this module edits retrieves channel images from the first module and overlays the ROIs as a mask and measures
// values to obtain mean intensity. dat_loc and reference/ index images are saved to a location on the computer

open(chnl_img + "Myosoft-1 typeIIa.tif");
roiManager("Show All with labels");
roiManager("Measure");
run("Flatten");

saveAs("Results", dat_loc + "Fiber_type_Results_typeIIa.csv");
saveAs("Tiff", dat_loc + "InputImageNameHere_referenceImg_typeIIa");

   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 

open(chnl_img + "Myosoft-1 typeIIb.tif");
roiManager("Show All with labels");
roiManager("Measure");
run("Flatten");

saveAs("Results", dat_loc + "Fiber_type_Results_typeIIb.csv");
saveAs("Tiff", dat_loc + "InputImageNameHere_referenceImg_typeIIb");

   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 

open(chnl_img + "Myosoft-1 typeI.tif");
roiManager("Show All with labels");
roiManager("Measure");
run("Flatten");

saveAs("Results", dat_loc + "Fiber_type_Results_typeI.csv");
saveAs("Tiff", dat_loc + "InputImageNameHere_referenceImg_typeI");


   if (isOpen("Results")) { 
       selectWindow("Results");
       run("Close"); 
   } 

open(chnl_img + "Myosoft-1 membrane.tif");
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

run("Close All");

waitForUser("Analysis Complete");