//
//  ViewController.swift
//  ConexionHTTP
//
//  Created by Gerardo Villarroel on 8/4/16.
//  Copyright © 2016 Gerardo Villarroel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var textoISBN: UITextField!
    @IBOutlet weak var scroll: UIScrollView!
    var textoSalidaWebService: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        textoISBN.delegate = self
        self.logo.image = UIImage(named: "logo_OL-lg")
        textoISBN.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        textoISBN.becomeFirstResponder()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let sigVista = segue.destinationViewController as! VistaResultados
        sigVista.textoISBN = sincrono(textoISBN.text!)
        
        //Cambiar nombre del botón BACK de un segue
        let backItem = UIBarButtonItem()
        backItem.title = "Atrás"
        navigationItem.backBarButtonItem = backItem
    }
    
    @IBAction func textFieldDidBeginEditing(textField: UITextField) {
        var punto: CGPoint
        punto = CGPointMake(0, textField.frame.origin.y - 50)
        self.scroll.setContentOffset(punto, animated: true)
    }
    
    @IBAction func textFieldDidEndEditing(textField: UITextField) {
        self.scroll.setContentOffset(CGPointZero, animated: true)
    }

    @IBAction func textFieldDoneEditing(sender: UITextField) {
        sender.resignFirstResponder() //desaparecer el teclado
    }
    
    func sincrono(textoISBN: String)-> String {
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(textoISBN)"
        let url = NSURL(string: urls)
        let datos: NSData?
        var resultado: String
        
        do {
            datos = try NSData(contentsOfURL: url!, options: NSDataReadingOptions())
            resultado = String(NSString(data: datos!, encoding: NSUTF8StringEncoding))
        }catch {
            resultado = String(error)
            let alertController = UIAlertController(title: "", message:
                "Por favor revisa tu conexión a Internet.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        return resultado
    }

    func asincrono(textoISBN: String) {
        /* incluir en Info.plist
        <key>NSAppTransportSecurity</key>
        <dict>
        <!--Permite todas las conexiones (cuidado) -->
        <key>NSAllowsArbitraryLoads</key>
        <true/>
        </dict>
        
        ó
        
        <key>NSAppTransportSecurity</key>
        <dict>
        <key>NSExceptionDomains</key>
        <dict>
        <key>dia.ccm.itesm.mx</key>
        <dict>
        <!--Incluir todos los subdominios-->
        <key>NSIncludesSubdomains</key>
        <true/>
        <!--Para que se pueda realizar peticiones HTTP-->
        <key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
        <true/>
        </dict>
        </dict>
        </dict>*/
        
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(textoISBN)"
        let url = NSURL(string: urls)
        let sesion = NSURLSession.sharedSession()
        let bloque = {
            (datos: NSData?, resp: NSURLResponse?, error: NSError?) -> Void in
            if (error != nil) {
                dispatch_sync(dispatch_get_main_queue()) {
                    self.controlarConexionInternet("")
                }
            } else {
                let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
                //print(texto)
                dispatch_sync(dispatch_get_main_queue()) {
                    self.controlarConexionInternet(String(texto))
                }
            }
        }
        let dt = sesion.dataTaskWithURL(url!, completionHandler: bloque)
        dt.resume()
    }
    
    func controlarConexionInternet(msj: String){
        if (msj != "") {
            textoSalidaWebService = String(msj)
            print("yes")
        } else {
            let alertController = UIAlertController(title: "", message:
                "Por favor revisa tu conexión a Internet.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            print("error")
        }
    }
}

