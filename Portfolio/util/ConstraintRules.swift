//
// Created by Knut Nygaard on 24/02/16.
// Copyright (c) 2016 APM solutions. All rights reserved.
//

import Foundation
import SnapKit

class ConstraintRules {

    var parentView: View!

    var i_height: Int?
    var i_marginTop: Int?
    var i_marginBottom: Int?
    var i_centerY: Bool?
    var i_snapTop: ConstraintItem?
    var i_snapBottom: ConstraintItem?

    var i_width: Int?
    var i_centerX: Bool?
    var i_marginLeft: Int?
    var i_marginRight: Int?
    var i_snapLeft: ConstraintItem?
    var i_snapRight: ConstraintItem?


    init(parentView: View) {
        self.parentView = parentView
    }

    func height(height: Int?) -> ConstraintRules {
        i_height = height
        return self
    }

    func marginTop(margin: Int) -> ConstraintRules {
        i_marginTop = margin
        return self
    }

    func marginBottom(margin: Int) -> ConstraintRules {
        i_marginBottom = margin
        return self
    }

    func centerY() -> ConstraintRules {
        i_centerY = true
        return self
    }

    func snapTop() -> ConstraintRules {
        i_snapTop = parentView.snp_top
        return self
    }

    func snapTop(snap: ConstraintItem) -> ConstraintRules {
        i_snapTop = snap
        return self
    }

    func snapBottom() -> ConstraintRules {
        i_snapBottom = parentView.snp_bottom
        return self
    }

    func snapBottom(snap: ConstraintItem) -> ConstraintRules {
        i_snapBottom = snap
        return self
    }

    func width(width: Int?) -> ConstraintRules {
        i_width = width
        return self
    }

    func centerX() -> ConstraintRules {
        i_centerX = true
        return self
    }

    func marginLeft(margin: Int) -> ConstraintRules {
        i_marginLeft = margin
        return self
    }

    func marginRight(margin: Int) -> ConstraintRules {
        i_marginRight = margin
        return self
    }

    func snapLeft() -> ConstraintRules {
        i_snapLeft = parentView.snp_left
        return self
    }

    func snapLeft(leftsnp: ConstraintItem) -> ConstraintRules {
        i_snapLeft = leftsnp
        return self
    }

    func snapRight() -> ConstraintRules {
        i_snapRight = parentView.snp_right
        return self
    }

    func snapRight(rightsnp: ConstraintItem) -> ConstraintRules {
        i_snapRight = rightsnp
        return self
    }

    func horizontalFullWithMargin(margin: Int) -> ConstraintRules {
        i_snapLeft = parentView.snp_left
        i_snapRight = parentView.snp_right
        i_marginLeft = margin
        i_marginRight = margin
        return self
    }
}
