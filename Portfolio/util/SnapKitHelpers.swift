import Foundation
import SnapKit

class SnapKitHelpers {

    static func setConstraints(components: [ComponentWrapper]) {
        for i in 0 ... components.count - 1 {
            let view = components[i].rules.parentView
            components[i].view.snp_makeConstraints() {
                (comp) -> Void in

                var marginTop = 0
                var marginBottom = 0
                var marginLeft = 0
                var marginRight = 0
                var offsetX = 0
                var offsetY = 0

                let constraints = components[i].rules

                //Snap top
                if let margin = constraints.i_marginTop {
                    marginTop = margin
                }

                if let snap = constraints.i_snapTop {
                    comp.top.equalTo(snap).offset(marginTop)
                }

                //Height
                if let height = constraints.i_height {
                    comp.height.equalTo(height)
                }

                //CenterY
                if let offset_y = constraints.i_offsetY {
                    offsetY = offset_y
                }

                if let _ = constraints.i_centerY {
                    comp.centerY.equalTo(view).offset(offsetY)
                }

                //Snap bottom
                if let margin = constraints.i_marginBottom {
                    marginBottom = margin
                }

                if let snap = constraints.i_snapBottom {
                    comp.bottom.equalTo(snap).offset(-marginBottom)
                }

                //Snap Left
                if let margin = constraints.i_marginLeft {
                    marginLeft = margin
                }

                if let snap = constraints.i_snapLeft {
                    comp.left.equalTo(snap).offset(marginLeft)
                }

                //Snap Right
                if let margin = constraints.i_marginRight {
                    marginRight = margin
                }

                if let snap = constraints.i_snapRight {
                    comp.right.equalTo(snap).offset(-marginRight)
                }

                //Width
                if let width = constraints.i_width {
                    comp.width.equalTo(width)
                }

                if let offset_x = constraints.i_offsetX {
                    offsetX = offset_x
                }
                //CenterX
                if let _ = constraints.i_centerX {
                    comp.centerX.equalTo(view.snp_centerX).offset(offsetX)
                }
            }
        }
    }

    static func updateConstraints(components: [ComponentWrapper]) {
        for i in 0 ... components.count - 1 {
            let view = components[i].rules.parentView
            components[i].view.snp_updateConstraints() {
                (comp) -> Void in

                var marginTop = 0
                var marginBottom = 0
                var marginLeft = 0
                var marginRight = 0

                let constraints = components[i].rules

                //Snap top
                if let margin = constraints.i_marginTop {
                    marginTop = margin
                }

                if let snap = constraints.i_snapTop {
                    comp.top.equalTo(snap).offset(marginTop)
                }

                //Height
                if let height = constraints.i_height {
                    comp.height.equalTo(height)
                }

                //CenterY
                if let _ = constraints.i_centerY {
                    comp.centerY.equalTo(view)
                }

                //Snap bottom
                if let margin = constraints.i_marginBottom {
                    marginBottom = margin
                }

                if let snap = constraints.i_snapBottom {
                    comp.bottom.equalTo(snap).offset(-marginBottom)
                }

                //Snap Left
                if let margin = constraints.i_marginLeft {
                    marginLeft = margin
                }

                if let snap = constraints.i_snapLeft {
                    comp.left.equalTo(snap).offset(marginLeft)
                }

                //Snap Right
                if let margin = constraints.i_marginRight {
                    marginRight = margin
                }

                if let snap = constraints.i_snapRight {
                    comp.right.equalTo(snap).offset(-marginRight)
                }

                //Width
                if let width = constraints.i_width {
                    comp.width.equalTo(width)
                }

                //CenterY
                if let _ = constraints.i_centerX {
                    comp.centerX.equalTo(view.snp_centerX)
                }
            }
        }
    }

}
