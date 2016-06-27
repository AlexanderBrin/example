//
//  ViewController.swift
//  RevealImageDemo
//
//  Created by Alexander on 07/06/16.
//  Copyright © 2016 Alexander Brin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var viewToDrawOn: UIView!
    @IBOutlet weak var imageToReveal: UIView!
    
    var circle:CAShapeLayer!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Фигура для нашего рисунка — окружность
        circle = CAShapeLayer()
        
        //Нарисуем её до самых краёв нашего UIView
        let radius = self.viewToDrawOn.frame.size.width / 2.0
        circle.position = CGPointZero
        let b = self.viewToDrawOn.bounds;
        //b.origin.x = b.origin.x - 100;
        
        
        circle.path = UIBezierPath(roundedRect: b,
                                   cornerRadius: radius).CGPath
            
        //Настраиваем цвета, которыми будет закрашена окружность и её контур
        circle.fillColor = UIColor.clearColor().CGColor;
        
        //Не пугайтесь — просто использовалась небольшая категория UIColor для быстрой инициализации цвета из строки в Hex, её вы тоже найдёте в исходниках
        
        circle.strokeColor = UIColor(hex:"ffd800").CGColor
        circle.lineWidth = 2.0
        self.viewToDrawOn.layer.addSublayer(circle)
        
        
        startAnimation()
    }

    func startAnimation()
    {
        //Создаём анимацию, анимируя конечную точку прорисовки контура, которая будет изменяться от 0 до 1 (где 1 — это полная окружность)
        let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
        drawAnimation.duration = 1.3
        drawAnimation.repeatCount = 1.0
        drawAnimation.fromValue = NSNumber(float:0.0)
        drawAnimation.toValue = NSNumber(float:1.0)
        drawAnimation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        
        circle.addAnimation(drawAnimation, forKey: "drawOutlineAnimation")
        
        
        
        // Анимация маски
        
        
        
        //Начальное и конечное значения радиуса маски
        let initialRadius:CGFloat = 0.0
        let finalRadius = self.imageToReveal.bounds.size.width / 2.0
        
        //Создаём слой, который будет содержать маску
        let revealShape = CAShapeLayer()
        revealShape.bounds = self.imageToReveal.bounds
        
        //Закрашиваем черным — подойдет любой цвет, кроме прозрачного
        revealShape.fillColor = UIColor.blackColor().CGColor
        
        //Собственно фигура, которая будем служить маской: начальная и конечная
        let startRect = CGRectMake(CGRectGetMidX(self.imageToReveal.bounds) - initialRadius,
                                   CGRectGetMidY(self.imageToReveal.bounds) - initialRadius,
                                   initialRadius * 2,
                                   initialRadius * 2);
        let startPath = UIBezierPath(roundedRect:startRect, cornerRadius:initialRadius)
        let endPath = UIBezierPath(roundedRect: self.imageToReveal.bounds, cornerRadius:finalRadius)
        
        
        
        revealShape.path = startPath.CGPath;
        revealShape.position = CGPointMake(CGRectGetMidX(self.imageToReveal.bounds) - initialRadius,
                                           CGRectGetMidY(self.imageToReveal.bounds) - initialRadius);
        
        //Итак, теперь на изображение наложена маска, и видна будет лишь та его часть, которая совпадает с маской
        self.imageToReveal.layer.mask = revealShape;
        
        //Теперь анимация. Мы анимируем свойство path — это граф, описывающий фигуру, в нашем случае окружность. Анимация осуществит плавный переход от маленькой окружности до большой
        let revealAnimationPath = CABasicAnimation(keyPath:"path")
        revealAnimationPath.fromValue = startPath.CGPath
        revealAnimationPath.toValue = endPath.CGPath
        
        revealAnimationPath.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        revealAnimationPath.duration = 1.3/2.0
        revealAnimationPath.repeatCount = 1.0
        
    
        //Для этой анимации мы также установим начальное время, так как она должна начаться лишь когда половина обрамляющей окружности уже прорисована
        revealAnimationPath.beginTime = CACurrentMediaTime() + 1.3/2.0
        revealAnimationPath.delegate = self;
        
        //Так как анимация стартует с задержкой, нужно удостовериться, что свойство hidden у картинки изменится только когда маска уже применена, т.е. когда начнётся анимация маски
        let timeToShow = dispatch_time(DISPATCH_TIME_NOW, Int64(1.3/2.0 * Double(NSEC_PER_SEC)))
        
        // так делать не правильно, но в демо сойдет
        dispatch_after(timeToShow, dispatch_get_main_queue(), {()
            self.imageToReveal.hidden = false;
        });
        
        revealShape.path = endPath.CGPath;
        revealShape.addAnimation(revealAnimationPath, forKey: "revealAnimation")
        
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func handleTap(recognizer: UITapGestureRecognizer)
    {
        self.imageToReveal.hidden = true;
            startAnimation()
    }

}

