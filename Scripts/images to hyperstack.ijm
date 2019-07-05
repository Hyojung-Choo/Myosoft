//////////////////////////////////////////////////////////////////////////////////////
// ------------------------------4 images to hyperstack-------------------------------- 
// author: Lucas Encarnacion-Rivera 
// contact: lencarn@emory.edu
// description: this script takes 4 images and converts it to a 4 channel hyperstack 
// which can be used in the myosoft code. 
//////////////////////////////////////////////////////////////////////////////////////
// intstructions: 
// 1) open 4 images. Even if you only need analysis for 2, open 4. The other 2 or 1 
//	  image can be a random one.  
// 2) for all 4 open images convert them to 8bit or 16bit 
// 3) close out any other open images such that the only open images are the 4
// 4) make sure in the open images you have your membrane image and your channel 
//    image(s). 
// 5) click "Run" 
////////////////////////////////////////////////////////////////////////////////////////

stack_name = getString("Title this stack", "Intensity Stack");
run("Images to Stack", "name=["+stack_name+"] title=[] use");
stack_name_new = getTitle();
run("Stack to Hyperstack...", "order=xyczt(default) channels=4 slices=1 frames=1 display=Color");
waitForUser("choose place to save this hyperstack");
stack_loc = getDirectory("choose place to save this stack");
saveAs("Tiff", stack_loc + stack_name_new);

