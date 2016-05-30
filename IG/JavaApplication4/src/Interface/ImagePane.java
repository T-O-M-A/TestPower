package Interface;

import java.awt.Graphics;
import java.awt.Image;
import javax.swing.JPanel;
 
public class ImagePane extends JPanel {
     
    private static final long   serialVersionUID    = 1L;
     
    protected Image buffer;    
     
    public ImagePane(Image buffer){
        this.buffer = buffer;
    }  
         
    public void paintComponent(Graphics g) {
       g.drawImage(buffer,5,15,null);
     }
}