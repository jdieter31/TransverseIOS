//
//  Shader.fsh
//  Transverse
//
//  Created by Justin on 5/20/16.
//  Copyright © 2016 Justin. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
