//
//  TextFields.swift
//  YDSKit
//
//  Created by Gilwoo Hwang on 2022/06/30.
//

import Foundation

public final class Outlined64TextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h64,
            variant: .outlined
        )
    }
}

public final class Outlined56TextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h56,
            variant: .outlined
        )
    }
}

public final class Outlined48BigTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h48Big,
            variant: .outlined
        )
    }
}

public final class Outlined48SmallTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h48Small,
            variant: .outlined
        )
    }
}

public final class Outlined40TextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h40,
            variant: .outlined
        )
    }
}

public final class Contained64TextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h64,
            color: YDSColor(name: "gray_25_c"),
            variant: .contained
        )
    }
}

public final class Contained56TextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h56,
            color: YDSColor(name: "gray_25_c"),
            variant: .contained
        )
    }
}

public final class Contained48BigTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h48Big,
            color: YDSColor(name: "gray_25_c"),
            variant: .contained
        )
    }
}

public final class Contained48SmallTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h48Small,
            color: YDSColor(name: "gray_25_c"),
            variant: .contained
        )
    }
}

public final class Contained40TextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h40,
            color: YDSColor(name: "gray_25_c"),
            variant: .contained
        )
    }
}

public final class Outlined64PasswordTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h64,
            contentsType: .password(secure: true),
            variant: .outlined
        )
    }
}

public final class Outlined56PasswordTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h56,
            contentsType: .password(secure: true),
            variant: .outlined
        )
    }
}

public final class Outlined48BigPasswordTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h48Big,
            contentsType: .password(secure: true),
            variant: .outlined
        )
    }
}

public final class Outlined48SmallPasswordTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h48Small,
            contentsType: .password(secure: true),
            variant: .outlined
        )
    }
}

public final class Outlined40PasswordTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h40,
            contentsType: .password(secure: true),
            variant: .outlined
        )
    }
}

public final class Contained64PasswordTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h64,
            contentsType: .password(secure: true),
            color: YDSColor(name: "gray_25_c"),
            variant: .contained
        )
    }
}

public final class Contained56PasswordTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h56,
            contentsType: .password(secure: true),
            color: YDSColor(name: "gray_25_c"),
            variant: .contained
        )
    }
}

public final class Contained48BigPasswordTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h48Big,
            contentsType: .password(secure: true),
            color: YDSColor(name: "gray_25_c"),
            variant: .contained
        )
    }
}

public final class Contained48SmallPasswordTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h48Small,
            contentsType: .password(secure: true),
            color: YDSColor(name: "gray_25_c"),
            variant: .contained
        )
    }
}

public final class Contained40PasswordTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h40,
            contentsType: .password(secure: true),
            color: YDSColor(name: "gray_25_c"),
            variant: .contained
        )
    }
}

public final class Outlined64SearchTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h64,
            contentsType: .search,
            variant: .outlined
        )
    }
}

public final class Outlined56SearchTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h56,
            contentsType: .search,
            variant: .outlined
        )
    }
}

public final class Outlined48BigSearchTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h48Big,
            contentsType: .search,
            variant: .outlined
        )
    }
}

public final class Outlined48SmallSearchTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h48Small,
            contentsType: .search,
            variant: .outlined
        )
    }
}

public final class Outlined44SearchTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h44,
            contentsType: .search,
            color: YDSColor(name: "gray_400_c"),
            firstResponderColor: YDSColor(name: "gray_400_c"),
            variant: .outlined
        )
    }
}

public final class Outlined40SearchTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h40,
            contentsType: .search,
            variant: .outlined
        )
    }
}

public final class Contained64SearchTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h64,
            contentsType: .search,
            color: YDSColor(name: "gray_25_c"),
            variant: .contained
        )
    }
}

public final class Contained56SearchTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h56,
            contentsType: .search,
            color: YDSColor(name: "gray_25_c"),
            variant: .contained
        )
    }
}

public final class Contained48BigSearchTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h48Big,
            contentsType: .search,
            color: YDSColor(name: "gray_25_c"),
            variant: .contained
        )
    }
}

public final class Contained48SmallSearchTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h48Small,
            contentsType: .search,
            color: YDSColor(name: "gray_25_c"),
            variant: .contained
        )
    }
}

public final class Contained40SearchTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h40,
            contentsType: .search,
            color: YDSColor(name: "gray_25_c"),
            variant: .contained
        )
    }
}

public final class Outlined64CertifiedTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h64,
            contentsType: .certified,
            variant: .outlined
        )
    }
}

public final class Outlined56CertifiedTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h56,
            contentsType: .certified,
            variant: .outlined
        )
    }
}

public final class Outlined48BigCertifiedTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h48Big,
            contentsType: .certified,
            variant: .outlined
        )
    }
}

public final class Outlined48SmallCertifiedTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h48Small,
            contentsType: .certified,
            variant: .outlined
        )
    }
}

public final class Outlined40CertifiedTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h40,
            contentsType: .certified,
            variant: .outlined
        )
    }
}

public final class Contained64CertifiedTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h64,
            contentsType: .certified,
            color: YDSColor(name: "gray_25_c"),
            variant: .contained
        )
    }
}

public final class Contained56CertifiedTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h56,
            contentsType: .certified,
            color: YDSColor(name: "gray_25_c"),
            variant: .contained
        )
    }
}

public final class Contained48BigCertifiedTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h48Big,
            contentsType: .certified,
            color: YDSColor(name: "gray_25_c"),
            variant: .contained
        )
    }
}

public final class Contained48SmallCertifiedTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h48Small,
            contentsType: .certified,
            color: YDSColor(name: "gray_25_c"),
            variant: .contained
        )
    }
}

public final class Contained40CertifiedTextField: TextField {

    public override var style: TextFieldStyle {
        TextFieldStyle(
            size: .h40,
            contentsType: .certified,
            color: YDSColor(name: "gray_25_c"),
            variant: .contained
        )
    }
}
