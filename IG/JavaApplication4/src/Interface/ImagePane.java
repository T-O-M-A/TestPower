package Interface;

import java.awt.Graphics;
import java.awt.Image;
import javax.swing.JPanel;
 
public class ImagePane extends JPanel {
     
    private static final long   serialVersionUID    = 1L;
     
    public Image buffer;  
    public int x;
    public int y;
     
    public ImagePane(Image buffer, int x, int y){
        this.buffer = buffer;
        this.x = x;
        this.y = y;
    }  
         
    @Override
    public void paintComponent(Graphics g) {
       g.drawImage(buffer,x,y,null);
     }
    
    public void setBuffer(Image img) {
        this.buffer = img;
    }
}