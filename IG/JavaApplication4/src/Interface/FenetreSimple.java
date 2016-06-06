/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Interface;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Image;
import java.awt.Point;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.imageio.ImageIO;
import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextField;
import org.rosuda.JRI.Rengine;

/**
 *
 * @author Lair Thomas, Bonjean Grégoire & Crépin Baptiste
 */
public class FenetreSimple extends Fenetre {

    String cas;

    public FenetreSimple(String title,
            final Dimension dim,
            Fenetre prec,
            Fenetre suiv,
            Fenetre home,
            Point location,
            final String cas) {
        super(title, dim, prec, suiv, home, location);
        fen = this;
        this.cas = cas;

        Image img;
        switch (cas) {
            case "Un Échantillon":
                try {
                    img = ImageIO.read(getClass().getResource("one_sample.gif"));
                } catch (IOException e) {
                    img = null;
                }
                break;
            case "Deux Échantillons Appariés":
                try {
                    img = ImageIO.read(getClass().getResource("paired.gif"));
                } catch (IOException e) {
                    img = null;
                }
                break;
            case "Corrélation de Pearson":
                try {
                    img = ImageIO.read(getClass().getResource("pearson.png"));
                } catch (IOException e) {
                    img = null;
                }
                break;
            case "ANOVA":
                try {
                    img = ImageIO.read(getClass().getResource("fisher.png"));
                } catch (IOException e) {
                    img = null;
                }
                break;
            case "Régression Simple":
                try {
                    img = ImageIO.read(getClass().getResource("simple_regression.png"));
                } catch (IOException e) {
                    img = null;
                }
                break;
            case "Régression avec Effets Mixtes":
                try {
                    img = ImageIO.read(getClass().getResource("mixed_effects.png"));
                } catch (IOException e) {
                    img = null;
                }
                break;
            case "Régression Multiple":
                try {
                    img = ImageIO.read(getClass().getResource("multiple_regression.jpg"));
                } catch (IOException e) {
                    img = null;
                }
                break;
            case "Régression Multiple avec Intéraction":
                try {
                    img = ImageIO.read(getClass().getResource("interaction.png"));
                } catch (IOException e) {
                    img = null;
                }
                break;
            default:
                try {
                    img = ImageIO.read(getClass().getResource("independant.gif"));
                } catch (IOException e) {
                    img = null;
                }
                break;
        }

        JPanel panCas = new ImagePane(img, 5, 15);
        panCas.setBackground(Color.white);
        panCas.setLayout(new BorderLayout());
        panCas.setPreferredSize(new Dimension((int) (dim.width * 0.95), (int) ((dim.height - 100) * 0.279)));
        panCas.setBorder(BorderFactory.createTitledBorder("Sous-cas : " + cas));

        JPanel panDescr = new JPanel();
        panDescr.setBackground(Color.gray);
        panDescr.setPreferredSize(new Dimension((int) (dim.width * 0.6675), (int) ((dim.height - 100) * 0.5)));
        panDescr.setBorder(BorderFactory.createTitledBorder("<html><font color = white >Description</font></html>"));
        panCas.add(panDescr, BorderLayout.EAST);

        this.getContentPane().add(panCas);

        JPanel panChoix = new JPanel();
        panChoix.setBackground(Color.white);
        panChoix.setLayout(new BorderLayout());
        panChoix.setPreferredSize(new Dimension((int) (dim.width * 0.95), (int) ((dim.height - 100) * 0.7)));
        panChoix.setBorder(BorderFactory.createTitledBorder("Renseignez l'un des groupes de champs"));

        JPanel panStudent = new JPanel();
        panStudent.setBackground(Color.lightGray);
        panStudent.setPreferredSize(new Dimension((int) (dim.width * 0.467), (int) ((dim.height - 100) * 0.3)));
        switch (cas) {
            case "Un Échantillon":
            case "Deux Échantillons Appariés":
            case "Deux Échantillons Indépendants":
                panStudent.setBorder(BorderFactory.createTitledBorder("t-Test de Student"));
                break;
            case "Corrélation de Pearson":
                panStudent.setBorder(BorderFactory.createTitledBorder("Test de Corrélation de Pearson"));
                break;
            case "ANOVA":
                panStudent.setBorder(BorderFactory.createTitledBorder("Test d'ANOVA"));
                break;
            default:
                panStudent.setBorder(BorderFactory.createTitledBorder(""));
                break;
        }

        JPanel panVerifSimple;
        JPanel panPuissanceSimple;
        switch (cas) {
            case "Un Échantillon":
            case "Deux Échantillons Appariés":
            case "Deux Échantillons Indépendants":
            case "ANOVA":
                panVerifSimple = new JPanel();
                panVerifSimple.setBackground(Color.gray);
                panVerifSimple.setPreferredSize(new Dimension((int) (dim.width * 0.458), (int) ((dim.height - 100) * 0.25)));
                panVerifSimple.setBorder(BorderFactory.createTitledBorder("Vérification du Test"));

                panPuissanceSimple = new JPanel();
                panPuissanceSimple.setBackground(Color.gray);
                panPuissanceSimple.setLayout(new BorderLayout());
                panPuissanceSimple.setPreferredSize(new Dimension((int) (dim.width * 0.458), (int) ((dim.height - 100) * 0.38)));
                panPuissanceSimple.setBorder(BorderFactory.createTitledBorder("Calcul de Puissance"));
                break;
            case "Corrélation de Pearson":
                panVerifSimple = new JPanel();
                panVerifSimple.setBackground(Color.gray);
                panVerifSimple.setPreferredSize(new Dimension((int) (dim.width * 0.458), (int) ((dim.height - 100) * 0.610)));
                panVerifSimple.setBorder(BorderFactory.createTitledBorder("Vérification du Test"));

                panPuissanceSimple = new JPanel();
                break;
            default:
                panVerifSimple = new JPanel();
                panVerifSimple.setBackground(Color.gray);
                panVerifSimple.setPreferredSize(new Dimension((int) (dim.width * 0.458), (int) ((dim.height - 100) * 0.305)));
                panVerifSimple.setBorder(BorderFactory.createTitledBorder("Vérification du Test"));

                panPuissanceSimple = new JPanel();
                panPuissanceSimple.setBackground(Color.gray);
                panPuissanceSimple.setLayout(new BorderLayout());
                panPuissanceSimple.setPreferredSize(new Dimension((int) (dim.width * 0.458), (int) ((dim.height - 100) * 0.305)));
                panPuissanceSimple.setBorder(BorderFactory.createTitledBorder("Calcul de Puissance"));
                break;
        }

        switch (cas) {
            case "Un Échantillon":
                JPanel panDonneesUn = new JPanel();
                panDonneesUn.setBackground(Color.lightGray);
                panDonneesUn.setPreferredSize(new Dimension((int) (dim.width * 0.44), (int) ((dim.height - 100) * 0.28)));
                panDonneesUn.setLayout(new BorderLayout());

                JPanel panPiloteUn = new JPanel();
                panPiloteUn.setBackground(Color.white);
                panPiloteUn.setPreferredSize(new Dimension((int) (dim.width * 0.22), (int) ((dim.height - 100) * 0.20)));
                panPiloteUn.setBorder(BorderFactory.createTitledBorder("Étude Pilote"));
                JLabel labelNbrPiloteUn = new JLabel("Taille du pilote :");
                JTextFieldControlled fieldNbrPiloteUn = new JTextFieldControlled();
                fieldNbrPiloteUn.setPreferredSize(new Dimension((int) (dim.width * 0.11), (int) ((dim.height - 100) * 0.045)));
                panPiloteUn.add(labelNbrPiloteUn);
                panPiloteUn.add(fieldNbrPiloteUn);
                JLabel labelMeandUn = new JLabel("Écart à la moyenne :");
                JTextFieldControlled fieldMeandUn = new JTextFieldControlled();
                fieldMeandUn.setPreferredSize(new Dimension((int) (dim.width * 0.089), (int) ((dim.height - 100) * 0.045)));
                panPiloteUn.add(labelMeandUn);
                panPiloteUn.add(fieldMeandUn);
                JLabel labelSigmaUn = new JLabel("Écart-type :");
                JTextFieldControlled fieldSigmaUn = new JTextFieldControlled();
                fieldSigmaUn.setPreferredSize(new Dimension((int) (dim.width * 0.135), (int) ((dim.height - 100) * 0.045)));
                panPiloteUn.add(labelSigmaUn);
                panPiloteUn.add(fieldSigmaUn);
                panDonneesUn.add(panPiloteUn, BorderLayout.WEST);

                JPanel panDroiteUn = new JPanel();
                panDroiteUn.setBackground(Color.white);
                panDroiteUn.setPreferredSize(new Dimension((int) (dim.width * 0.22), (int) ((dim.height - 100) * 0.28)));
                panDroiteUn.setLayout(new BorderLayout());

                JPanel panSimuUn = new JPanel();
                panSimuUn.setBackground(Color.white);
                panSimuUn.setPreferredSize(new Dimension((int) (dim.width * 0.22), (int) ((dim.height - 100) * 0.19)));
                panSimuUn.setBorder(BorderFactory.createTitledBorder("Simulations"));
                JLabel labelNbrBSUn = new JLabel("Nombre de Bootstrap :");
                JTextFieldControlled fieldNbrBSUn = new JTextFieldControlled();
                fieldNbrBSUn.setPreferredSize(new Dimension((int) (dim.width * 0.07), (int) ((dim.height - 100) * 0.045)));
                panSimuUn.add(labelNbrBSUn);
                panSimuUn.add(fieldNbrBSUn);
                JLabel labelNbrMCUn = new JLabel("Nombre de Monte-Carlo :");
                JTextFieldControlled fieldNbrMCUn = new JTextFieldControlled();
                fieldNbrMCUn.setPreferredSize(new Dimension((int) (dim.width * 0.053), (int) ((dim.height - 100) * 0.045)));
                panSimuUn.add(labelNbrMCUn);
                panSimuUn.add(fieldNbrMCUn);
                JLabel labelTailleMCUn = new JLabel("Taille des Monte-Carlo :");
                JTextFieldControlled fieldTailleMCUn = new JTextFieldControlled();
                fieldTailleMCUn.setPreferredSize(new Dimension((int) (dim.width * 0.06), (int) ((dim.height - 100) * 0.045)));
                panSimuUn.add(labelTailleMCUn);
                panSimuUn.add(fieldTailleMCUn);

                JPanel panPuissanceUn = new JPanel();
                panPuissanceUn.setBackground(Color.white);
                panPuissanceUn.setPreferredSize(new Dimension((int) (dim.width * 0.22), (int) ((dim.height - 100) * 0.08)));
                JLabel labelPuissanceUn = new JLabel("Puissance :");
                JTextFieldControlled fieldPuissanceUn = new JTextFieldControlled();
                fieldPuissanceUn.setPreferredSize(new Dimension((int) (dim.width * 0.09), (int) ((dim.height - 100) * 0.045)));
                panPuissanceUn.add(labelPuissanceUn);
                panPuissanceUn.add(fieldPuissanceUn);

                panDroiteUn.add(panSimuUn, BorderLayout.NORTH);
                panDroiteUn.add(panPuissanceUn, BorderLayout.SOUTH);

                panDonneesUn.add(panDroiteUn, BorderLayout.EAST);

                final JButton boutonValUn = new JButton("Valider");
                boutonValUn.setPreferredSize(new Dimension((int) (dim.width * 0.22), (int) ((dim.height - 100) * 0.15)));

                panChoix.add(panStudent, BorderLayout.WEST);
//                final Rengine eng = new Rengine(new String[]{"--no-save"}, false, null);
//                boutonValUn.addActionListener(new ActionListener() {
//                    public void actionPerformed(ActionEvent event) {
//                        boutonValUn.setEnabled(false);
//
//                        if (!eng.waitForR()) {
//                            System.out.println("Cannot load R");
//                            System.exit(1);
//                        }
//                        eng.eval("x=seq(0,2,by=0.01)");
//                        eng.eval("y=2*sin(2*pi*(x-1/4))");
//                        eng.eval("jpeg('/home/thomas/Bureau/ProjetSpe/Projet-Specialite-Calcul-de-Puissance/IG/JavaApplication4/src/Interface/rplot.jpg')");
//                        eng.eval("plot(x,y)");
//                        eng.eval("dev.off()");
//                        System.out.println("bla");
//
//                        Image img;
//
//                        try {
//                            img = ImageIO.read(getClass().getResource("rplot.jpg"));
//                            img.getScaledInstance(600, 600, Image.SCALE_DEFAULT);
//                        } catch (IOException ex) {
//                            img = null;
//                            Logger.getLogger(FenetreSimple.class.getName()).log(Level.SEVERE, null, ex);
//                        }
//                        boutonValUn.setEnabled(true);
//                    }
//                }
//                );

                panPuissanceSimple.add(panDonneesUn, BorderLayout.NORTH);
                panPuissanceSimple.add(boutonValUn);

                panStudent.add(panVerifSimple);
                panStudent.add(panPuissanceSimple);
                break;

            case "Deux Échantillons Appariés":
                JPanel panDonneesApp = new JPanel();
                panDonneesApp.setBackground(Color.lightGray);
                panDonneesApp.setPreferredSize(new Dimension((int) (dim.width * 0.44), (int) ((dim.height - 100) * 0.28)));
                panDonneesApp.setLayout(new BorderLayout());

                JPanel panPiloteApp = new JPanel();
                panPiloteApp.setBackground(Color.white);
                panPiloteApp.setPreferredSize(new Dimension((int) (dim.width * 0.22), (int) ((dim.height - 100) * 0.20)));
                panPiloteApp.setBorder(BorderFactory.createTitledBorder("Étude Pilote"));
                JLabel labelNbrPiloteApp = new JLabel("Taille du pilote :");

                JTextFieldControlled fieldNbrPiloteApp = new JTextFieldControlled();
                fieldNbrPiloteApp.setPreferredSize(new Dimension((int) (dim.width * 0.11), (int) ((dim.height - 100) * 0.045)));
                panPiloteApp.add(labelNbrPiloteApp);
                panPiloteApp.add(fieldNbrPiloteApp);
                JLabel labelMeandApp = new JLabel("Différence de moyennes :");
                JTextFieldControlled fieldMeandApp = new JTextFieldControlled();
                fieldMeandApp.setPreferredSize(new Dimension((int) (dim.width * 0.058), (int) ((dim.height - 100) * 0.045)));
                panPiloteApp.add(labelMeandApp);
                panPiloteApp.add(fieldMeandApp);
                JLabel labelSigmaApp = new JLabel("Écart-types :");
                JTextFieldControlled fieldSigmaUnApp = new JTextFieldControlled();
                JTextFieldControlled fieldSigmaDeuxApp = new JTextFieldControlled();
                fieldSigmaUnApp.setPreferredSize(new Dimension((int) (dim.width * 0.063), (int) ((dim.height - 100) * 0.045)));
                fieldSigmaDeuxApp.setPreferredSize(new Dimension((int) (dim.width * 0.063), (int) ((dim.height - 100) * 0.045)));
                panPiloteApp.add(labelSigmaApp);
                panPiloteApp.add(fieldSigmaUnApp);
                panPiloteApp.add(fieldSigmaDeuxApp);
                JLabel labelCFApp = new JLabel("Facteur de corrélation :");
                JTextFieldControlled fieldCFApp = new JTextFieldControlled();
                fieldCFApp.setPreferredSize(new Dimension((int) (dim.width * 0.071), (int) ((dim.height - 100) * 0.045)));
                panPiloteApp.add(labelCFApp);
                panPiloteApp.add(fieldCFApp);
                panDonneesApp.add(panPiloteApp, BorderLayout.WEST);

                JPanel panDroiteApp = new JPanel();
                panDroiteApp.setBackground(Color.white);
                panDroiteApp.setPreferredSize(new Dimension((int) (dim.width * 0.22), (int) ((dim.height - 100) * 0.28)));
                panDroiteApp.setLayout(new BorderLayout());

                JPanel panSimuApp = new JPanel();
                panSimuApp.setBackground(Color.white);
                panSimuApp.setPreferredSize(new Dimension((int) (dim.width * 0.22), (int) ((dim.height - 100) * 0.19)));
                panSimuApp.setBorder(BorderFactory.createTitledBorder("Simulations"));
                JLabel labelNbrBSApp = new JLabel("Nombre de Bootstrap :");
                JTextFieldControlled fieldNbrBSApp = new JTextFieldControlled();
                fieldNbrBSApp.setPreferredSize(new Dimension((int) (dim.width * 0.07), (int) ((dim.height - 100) * 0.045)));
                panSimuApp.add(labelNbrBSApp);
                panSimuApp.add(fieldNbrBSApp);
                JLabel labelNbrMCApp = new JLabel("Nombre de Monte-Carlo :");
                JTextFieldControlled fieldNbrMCApp = new JTextFieldControlled();
                fieldNbrMCApp.setPreferredSize(new Dimension((int) (dim.width * 0.053), (int) ((dim.height - 100) * 0.045)));
                panSimuApp.add(labelNbrMCApp);
                panSimuApp.add(fieldNbrMCApp);
                JLabel labelTailleMCApp = new JLabel("Taille des Monte-Carlo :");
                JTextFieldControlled fieldTailleMCApp = new JTextFieldControlled();
                fieldTailleMCApp.setPreferredSize(new Dimension((int) (dim.width * 0.06), (int) ((dim.height - 100) * 0.045)));
                panSimuApp.add(labelTailleMCApp);
                panSimuApp.add(fieldTailleMCApp);

                JPanel panPuissanceApp = new JPanel();
                panPuissanceApp.setBackground(Color.white);
                panPuissanceApp.setPreferredSize(new Dimension((int) (dim.width * 0.22), (int) ((dim.height - 100) * 0.08)));
                JLabel labelPuissanceApp = new JLabel("Puissance :");
                JTextFieldControlled fieldPuissanceApp = new JTextFieldControlled();
                fieldPuissanceApp.setPreferredSize(new Dimension((int) (dim.width * 0.09), (int) ((dim.height - 100) * 0.045)));
                panPuissanceApp.add(labelPuissanceApp);
                panPuissanceApp.add(fieldPuissanceApp);

                panDroiteApp.add(panSimuApp, BorderLayout.NORTH);
                panDroiteApp.add(panPuissanceApp, BorderLayout.SOUTH);

                panDonneesApp.add(panDroiteApp, BorderLayout.EAST);

                JButton boutonValApp = new JButton("Valider");
                boutonValApp.setPreferredSize(new Dimension((int) (dim.width * 0.22), (int) ((dim.height - 100) * 0.15)));

                panPuissanceSimple.add(panDonneesApp, BorderLayout.NORTH);
                panPuissanceSimple.add(boutonValApp);

                panStudent.add(panVerifSimple);
                panStudent.add(panPuissanceSimple);
                break;
            case "Corrélation de Pearson":
                panStudent.add(panVerifSimple);
                break;
            case "ANOVA":
                panStudent.add(panVerifSimple);
                panStudent.add(panPuissanceSimple);
                break;
            default:
                JPanel panDonneesInd = new JPanel();
                panDonneesInd.setBackground(Color.lightGray);
                panDonneesInd.setPreferredSize(new Dimension((int) (dim.width * 0.44), (int) ((dim.height - 100) * 0.28)));
                panDonneesInd.setLayout(new BorderLayout());

                JPanel panPiloteInd = new JPanel();
                panPiloteInd.setBackground(Color.white);
                panPiloteInd.setPreferredSize(new Dimension((int) (dim.width * 0.22), (int) ((dim.height - 100) * 0.20)));
                panPiloteInd.setBorder(BorderFactory.createTitledBorder("Étude Pilote"));
                JLabel labelNbrPiloteInd = new JLabel("Taille des pilotes :");
                JTextFieldControlled fieldNbrPiloteInd = new JTextFieldControlled();
                fieldNbrPiloteInd.setPreferredSize(new Dimension((int) (dim.width * 0.098), (int) ((dim.height - 100) * 0.045)));
                panPiloteInd.add(labelNbrPiloteInd);
                panPiloteInd.add(fieldNbrPiloteInd);
                JLabel labelMeandInd = new JLabel("Différence de moyennes :");
                JTextFieldControlled fieldMeandInd = new JTextFieldControlled();
                fieldMeandInd.setPreferredSize(new Dimension((int) (dim.width * 0.058), (int) ((dim.height - 100) * 0.045)));
                panPiloteInd.add(labelMeandInd);
                panPiloteInd.add(fieldMeandInd);
                JLabel labelSigmaInd = new JLabel("Écart-type :");
                JTextFieldControlled fieldSigmaInd = new JTextFieldControlled();
                fieldSigmaInd.setPreferredSize(new Dimension((int) (dim.width * 0.135), (int) ((dim.height - 100) * 0.045)));
                panPiloteInd.add(labelSigmaInd);
                panPiloteInd.add(fieldSigmaInd);
                panDonneesInd.add(panPiloteInd, BorderLayout.WEST);

                JPanel panDroiteInd = new JPanel();
                panDroiteInd.setBackground(Color.white);
                panDroiteInd.setPreferredSize(new Dimension((int) (dim.width * 0.22), (int) ((dim.height - 100) * 0.28)));
                panDroiteInd.setLayout(new BorderLayout());

                JPanel panSimuInd = new JPanel();
                panSimuInd.setBackground(Color.white);
                panSimuInd.setPreferredSize(new Dimension((int) (dim.width * 0.22), (int) ((dim.height - 100) * 0.19)));
                panSimuInd.setBorder(BorderFactory.createTitledBorder("Simulations"));
                JLabel labelNbrBSInd = new JLabel("Nombre de Bootstrap :");
                JTextFieldControlled fieldNbrBSInd = new JTextFieldControlled();
                fieldNbrBSInd.setPreferredSize(new Dimension((int) (dim.width * 0.07), (int) ((dim.height - 100) * 0.045)));
                panSimuInd.add(labelNbrBSInd);
                panSimuInd.add(fieldNbrBSInd);
                JLabel labelNbrMCInd = new JLabel("Nombre de Monte-Carlo :");
                JTextFieldControlled fieldNbrMCInd = new JTextFieldControlled();
                fieldNbrMCInd.setPreferredSize(new Dimension((int) (dim.width * 0.053), (int) ((dim.height - 100) * 0.045)));
                panSimuInd.add(labelNbrMCInd);
                panSimuInd.add(fieldNbrMCInd);
                JLabel labelTailleMCInd = new JLabel("Taille des Monte-Carlo :");
                JTextFieldControlled fieldTailleMCInd = new JTextFieldControlled();
                fieldTailleMCInd.setPreferredSize(new Dimension((int) (dim.width * 0.06), (int) ((dim.height - 100) * 0.045)));
                panSimuInd.add(labelTailleMCInd);
                panSimuInd.add(fieldTailleMCInd);

                JPanel panPuissanceInd = new JPanel();
                panPuissanceInd.setBackground(Color.white);
                panPuissanceInd.setPreferredSize(new Dimension((int) (dim.width * 0.22), (int) ((dim.height - 100) * 0.08)));
                JLabel labelPuissanceInd = new JLabel("Puissance :");
                JTextFieldControlled fieldPuissanceInd = new JTextFieldControlled();
                fieldPuissanceInd.setPreferredSize(new Dimension((int) (dim.width * 0.09), (int) ((dim.height - 100) * 0.045)));
                panPuissanceInd.add(labelPuissanceInd);
                panPuissanceInd.add(fieldPuissanceInd);

                panDroiteInd.add(panSimuInd, BorderLayout.NORTH);
                panDroiteInd.add(panPuissanceInd, BorderLayout.SOUTH);

                panDonneesInd.add(panDroiteInd, BorderLayout.EAST);

                JButton boutonValInd = new JButton("Valider");
                boutonValInd.setPreferredSize(new Dimension((int) (dim.width * 0.22), (int) ((dim.height - 100) * 0.15)));

                panPuissanceSimple.add(panDonneesInd, BorderLayout.NORTH);
                panPuissanceSimple.add(boutonValInd);

                panStudent.add(panVerifSimple);
                panStudent.add(panPuissanceSimple);
                break;
        }

        JPanel panObs = new JPanel();
        panObs.setBackground(Color.white);
        panObs.setPreferredSize(new Dimension((int) (dim.width * 0.467), (int) ((dim.height - 100) * 0.3)));
        panObs.setBorder(BorderFactory.createTitledBorder("Résultats"));
        panChoix.add(panObs, BorderLayout.EAST);

        this.getContentPane().add(panChoix);

        this.addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                if (JOptionPane.showConfirmDialog(fen,
                        "Voulez-vous fermer l'application ?", "Fermeture ?",
                        JOptionPane.YES_NO_OPTION,
                        JOptionPane.QUESTION_MESSAGE) == JOptionPane.YES_OPTION) {
                    System.exit(0);
                } else {
                    FenetreSimple new_fen = new FenetreSimple("Fenetre Principale",
                            new Dimension(fen.getWidth(), fen.getHeight()), fen.prec, fen.suiv, fen.home, fen.getLocation(), cas);
                }
            }
        }
        );
    }
}
