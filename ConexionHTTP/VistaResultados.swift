//
//  VistaResultados.swift
//  ConexionHTTP
//
//  Created by Gerardo Villarroel on 9/4/16.
//  Copyright © 2016 Gerardo Villarroel. All rights reserved.
//

import UIKit

class VistaResultados: UIViewController {

    @IBOutlet weak var resultadoISBN: UITextView!
    var textoISBN: String = "Prueba!"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        //Recuperación de los datos para mostrarlos en el segue.
        if (textoISBN == "Optional({})") {
            resultadoISBN.text = "El ISBN ingresado no corresponde a ningun Libro!"
        }
        else {
            resultadoISBN.text = textoISBN
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
