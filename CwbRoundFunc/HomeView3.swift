
import UIKit

class HomeView3: UIView ,CAAnimationDelegate{

    @IBOutlet weak var bgView: UIView!
    
    ///动画
    fileprivate var animLayer:CAShapeLayer?
    ///当前角度
    fileprivate var currentAngle:CGFloat = 0.0
    ///是否可点击执行动画
    fileprivate var isCanAnimotion = true
    ///中心点
    fileprivate var pointCenter = CGPoint.init()
    ///功能按钮数组
    fileprivate var funcView = [UIImageView]()
    ///功能按钮中心点位置
    fileprivate var funCenter = [CGPoint]()
    ///选中的位子
    fileprivate var selecIndex = 0
    ///信息label1
    fileprivate var infoLabel1:UILabel?
    ///信息label2
    fileprivate var infoLabel2:UILabel?
    ///数据源数组
    fileprivate var HomeDataArray = [HomeDataModel]()
    ///功能按钮位置角度
    fileprivate let angs:[CGFloat] = [30,50,75,105,130,150]
    ///功能按钮图片
    fileprivate let imgs1 = [UIImage.init(named: "sp1_img"),UIImage.init(named: "bj1_img"),UIImage.init(named: "bq1_img"),UIImage.init(named: "xl1_img"),UIImage.init(named: "gh1_img"),UIImage.init(named: "ck1_img")]
    ///功能按钮选中图片
    fileprivate let imgs2 = [UIImage.init(named: "sp2_img"),UIImage.init(named: "bj2_img"),UIImage.init(named: "bq2_img"),UIImage.init(named: "xl2_img"),UIImage.init(named: "gh2_img"),UIImage.init(named: "ck2_img")]
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for vi in self.bgView.subviews{
            vi.removeFromSuperview()
        }
        if self.bgView.layer.sublayers != nil {
            for layer in self.bgView.layer.sublayers!{
                layer.removeFromSuperlayer()
            }
        }
        ///初始化数据源
        if self.HomeDataArray.count > 0 {
            self.HomeDataArray.removeAll()
        }
        for i in 0..<angs.count {
            let model = HomeDataModel()
            model.Title = "标题\(i + 1)"
            model.Info = "信息\(i + 1)信息\(i + 1)信息\(i + 1)信息\(i + 1)信息\(i + 1)信息\(i + 1)"
            self.HomeDataArray.append(model)
        }
        pointCenter = CGPoint.init(x: frame.size.width * 0.5, y: frame.size.height - 20)
        UIGraphicsBeginImageContext(self.bounds.size)
        ///外半圆
        let path = UIBezierPath.init()
        path.addArc(withCenter: CGPoint.init(x: pointCenter.x, y: pointCenter.y), radius: frame.size.height * 0.5, startAngle: 0, endAngle: CGFloat(Double.pi), clockwise: false)
        
        let layer = CAShapeLayer.init()
        layer.lineWidth = 1
        layer.strokeColor = UIColor.init(red: 169 / 255, green: 220 / 255, blue: 242 / 255, alpha: 1).cgColor
        layer.fillColor = UIColor.clear.cgColor
        path.stroke()
        layer.path = path.cgPath
        self.bgView.layer.addSublayer(layer)
        ///创建三角
        self.creatPoint()
        ///遮盖圆
        let path1 = UIBezierPath.init()
        path1.addArc(withCenter: CGPoint.init(x: pointCenter.x, y: pointCenter.y), radius: frame.size.height * 0.5 - 1, startAngle: 0, endAngle: CGFloat(Double.pi), clockwise: false)
        
        let layer1 = CAShapeLayer.init()
        layer1.lineWidth = 1
        layer1.strokeColor = UIColor.white.cgColor
        layer1.fillColor = UIColor.white.cgColor
        path1.stroke()
        layer1.path = path1.cgPath
        self.bgView.layer.addSublayer(layer1)
        
        ///内阴影半圆
        let rView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)))
        rView.backgroundColor = UIColor.clear
        let cenView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: frame.size.height - 70, height: frame.size.height - 70))
        cenView.center = CGPoint.init(x: pointCenter.x, y: pointCenter.y)
        cenView.layer.masksToBounds = true
        cenView.layer.cornerRadius = cenView.bounds.size.width * 0.5
        cenView.backgroundColor = UIColor.white
        cenView.layer.borderColor = UIColor.init(red: 169 / 255, green: 220 / 255, blue: 242 / 255, alpha: 1).cgColor
        cenView.layer.borderWidth = 0.3
        rView.addSubview(cenView)
        rView.layer.shadowColor = UIColor.init(red: 169/255, green: 220/255, blue: 242/255, alpha: 1).cgColor
        rView.layer.shadowOpacity = 1
        rView.layer.shadowRadius = 7
        self.bgView.addSubview(rView)
        
        UIGraphicsEndImageContext()
        ///创建功能图片
        self.creatFunButton()
    }
    ///图片按钮创建
    fileprivate func creatFunButton(){
        
        if self.funCenter.count > 0 {
            self.funCenter.removeAll()
        }
        if self.funcView.count > 0 {
            self.funcView.removeAll()
        }
        for (index,ang) in angs.enumerated() {
            let point = self.calcCirclePoint(center: pointCenter, angle: ang, radius: frame.size.height * 0.5 + 50)
            self.funCenter.append(point)
            let funView = UIImageView.init()
            if self.selecIndex == index {
                funView.frame = CGRect.init(x: 0, y: 0, width: 50, height: 50)
            }
            else{
                funView.frame = CGRect.init(x: 0, y: 0, width: 37, height: 37)
            }
            funView.image = imgs1[index]
            funView.center = point
            self.bgView.addSubview(funView)
            
            let btn = UIButton.init(frame: funView.frame)
            btn.tag = index
            btn.addTarget(self, action: #selector(funcButtonAction(btn:)), for: .touchUpInside)
            self.bgView.addSubview(btn)
            self.funcView.append(funView)
        }
        self.animotion(angle: self.angs[self.selecIndex])
        self.isCanAnimotion = false
        
        ///添加信息label
        self.infoLabel1 = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 30))
        self.infoLabel1?.textColor = UIColor.red
        self.infoLabel1?.textAlignment = .center
        self.infoLabel1?.center = CGPoint.init(x: pointCenter.x, y: frame.size.height * 0.5 + 45)
        self.infoLabel1?.font = UIFont.systemFont(ofSize: 14.0)
        self.addSubview(self.infoLabel1!)
        
        self.infoLabel2 = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: (self.frame.size.height - 70) - 20, height: 80))
        self.infoLabel2?.numberOfLines = 0
        self.infoLabel2?.textAlignment = .center
        self.infoLabel2?.center = CGPoint.init(x: pointCenter.x, y: frame.size.height - 40)
        self.infoLabel2?.font = UIFont.systemFont(ofSize: 12.0)
        self.addSubview(self.infoLabel2!)
    }
    ///功能按钮事件
    @objc fileprivate  func funcButtonAction(btn:UIButton){
        if self.isCanAnimotion {
            self.funcView[self.selecIndex].frame.size = CGSize.init(width: 37, height: 37)
            self.funcView[self.selecIndex].image = imgs1[self.selecIndex]
            self.funcView[self.selecIndex].center = self.funCenter[self.selecIndex]
            self.funcView[btn.tag].frame.size = CGSize.init(width: 50, height: 50)
            self.funcView[btn.tag].image = imgs2[btn.tag]
            self.funcView[btn.tag].center = self.funCenter[btn.tag]
            self.selecIndex = btn.tag
            self.animotion(angle: self.angs[self.selecIndex])
            self.isCanAnimotion = false
        }
    }
    
    //MARK:根据角度计算圆上的坐标
    fileprivate func calcCirclePoint(center:CGPoint,angle:CGFloat,radius:CGFloat) -> CGPoint{
        let x2 = radius * CGFloat(cos(Float(angle * CGFloat(Double.pi / 180.0))))
        let y2 = radius * CGFloat(sin(Float(angle * CGFloat(Double.pi / 180.0))))
        return CGPoint.init(x: center.x + x2, y: center.y - y2)
    }
    ///创建三件尖
    fileprivate func creatPoint(){
        
        let height = frame.size.height + 46
        let width:CGFloat = 140
        
        let path1 = UIBezierPath.init()
        path1.lineWidth = 1
        path1.move(to: CGPoint.init(x: width * 0.5, y: 0))
        let point1 = CGPoint.init(x: 0, y: height * 0.5)
        let point2 = CGPoint.init(x: width, y: height * 0.5)
        path1.addLine(to: point2)
        path1.addLine(to: point1)
        path1.close()
        path1.stroke()
        animLayer = CAShapeLayer.init()
        animLayer?.frame = CGRect.init(x: frame.size.width * 0.5 - width * 0.5, y: frame.size.height - height * 0.5 - 20, width: width, height: height)
        animLayer?.strokeColor = UIColor.init(red: 169/255, green: 220/255, blue: 242/255, alpha: 1).cgColor
        animLayer?.fillColor = UIColor.white.cgColor
        animLayer?.path = path1.cgPath
        self.bgView.layer.addSublayer(animLayer!)
        self.currentAngle = 0
    }
    ///三角尖动画
    fileprivate func animotion(angle:CGFloat){
        let ani = CABasicAnimation.init(keyPath: "transform.rotation.z")
        ani.isRemovedOnCompletion = false
        ani.fillMode = CAMediaTimingFillMode.forwards
        var durDis = self.currentAngle - angle
        if durDis < 0 {
            durDis = -durDis
        }
        var duration = 0.3
        switch durDis {
        case 120:
            duration = 0.3
            break
        case 100:
            duration = 0.28
            break
        case 75:
            duration = 0.26
            break
        case 45:
            duration = 0.24
            break
        case 20,25,30:
            duration = 0.20
            break
        default:
            break
        }
        
        ani.duration = duration
        ani.fromValue = self.currentAngle / 180 * CGFloat(Double.pi)
        ani.toValue = (90 - angle) / 180 * CGFloat(Double.pi)
        ani.beginTime = CACurrentMediaTime()
        ani.delegate = self
        self.animLayer?.add(ani, forKey: nil)
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            if let base = anim as? CABasicAnimation {
                if let endAng = base.toValue as? CGFloat {
                    self.currentAngle = endAng / CGFloat(Double.pi) * 180
                    self.isCanAnimotion = true
                    if self.HomeDataArray.count == 6 {
                        let model = self.HomeDataArray[self.selecIndex]
                        self.setInfoLabelValue(str1: model.Title!, str2: model.Info!)
                    }
                }
            }
        }
    }
    ///设置信息label的值
    func setInfoLabelValue(str1:String,str2:String){
        self.infoLabel1?.text = str1
        self.infoLabel2?.text = str2
    }
    ///点击动画
//    fileprivate func clickCalAction(point:CGPoint){
//        if point.y < self.frame.size.height - 10{
//            let a:CGFloat = self.frame.size.height - 10
//            let b:CGFloat = 0
//
//            let c:CGFloat = point.x - self.frame.size.width * 0.5
//            let d:CGFloat = point.y - self.frame.size.height - 10
//
//            let rads = acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))))
//            let ang = rads * 180.0 / CGFloat(Double.pi)
//            self.animotion(angle: ang)
//            self.isCanAnimotion = false
//        }
//    }
}

