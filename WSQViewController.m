//
//  WSQViewController.m
//  OpenGL_Test
//
//  Created by Shouqiang Wei on 14-7-14.
//  Copyright (c) 2014年 Shouqiang Wei. All rights reserved.
//

#import "WSQViewController.h"
#import  <OpenGLES/EAGL.h>
#import <GLKit/GLKit.h>

//Vertex 定点 极点。头顶。
/*
typedef struct
{
    float Position[3];
    float Color[4];
} Vertex;

const Vertex Vertices[] =
{
    {
        {1, -1, 0},
        {1, 0, 0, 1}
    },
    {
        {1, 1, 0},
        {0, 1, 0, 1}
    },
    {
        {-1, 1, 0},
        {0, 0, 1, 1}
    },
    {
        {-1, -1, 0},
        {0, 0, 0, 1}
    }


};

const GLubyte Indices[] =
{
    0, 1, 2,2, 3, 0,2,3,4
};

*/

/*
const GLubyte Indices[] =
{
    0, 1, 2,2, 3, 0,2,3,4
};
typedef struct
{
    float Position[3];
    float Color[4];
    float TexCoord[2];
} Vertex;

const Vertex Vertices[] = {
    {{1, -1, 0},{1, 0, 0, 1}, {1, 0}},
    {{1, 1, 0}, {0, 1, 0, 1}, {1, 1}},
    {{-1, 1, 0}, {0, 0, 1, 1}, {0, 1}},
    {{-1, -1, 0}, {0, 0, 0, 1}, {0, 0}}
};

*/
typedef struct
{
    float Position[3];
    float Color[4];
    float TexCoord[2];
} Vertex;

const Vertex Vertices[] =
{ // Front
    {{1, -1, 1}, {1, 0, 0, 1}, {1, 0}},
    {{1, 1, 1}, {0, 1, 0, 1}, {1, 1}},
    {{-1, 1, 1}, {0, 0, 1, 1}, {0, 1}}, {{-1, -1, 1}, {0, 0, 0, 1}, {0, 0}},
    // Back
    {{1, 1, -1}, {1, 0, 0, 1}, {0, 1}}, {{-1, -1, -1}, {0, 1, 0, 1}, {1, 0}}, {{1, -1, -1}, {0, 0, 1, 1}, {0, 0}}, {{-1, 1, -1}, {0, 0, 0, 1}, {1, 1}}, // Left
    {{-1, -1, 1}, {1, 0, 0, 1}, {1, 0}}, {{-1, 1, 1}, {0, 1, 0, 1}, {1, 1}}, {{-1, 1, -1}, {0, 0, 1, 1}, {0, 1}}, {{-1, -1, -1}, {0, 0, 0, 1}, {0, 0}}, // Right
    {{1, -1, -1}, {1, 0, 0, 1}, {1, 0}}, {{1, 1, -1}, {0, 1, 0, 1}, {1, 1}}, {{1, 1, 1}, {0, 0, 1, 1}, {0, 1}}, {{1, -1, 1}, {0, 0, 0, 1}, {0, 0}}, // Top
    {{1, 1, 1}, {1, 0, 0, 1}, {1, 0}}, {{1, 1, -1}, {0, 1, 0, 1}, {1, 1}}, {{-1, 1, -1}, {0, 0, 1, 1}, {0, 1}}, {{-1, 1, 1}, {0, 0, 0, 1}, {0, 0}},
    // Bottom
    {{1, -1, -1}, {1, 0, 0, 1}, {1, 0}}, {{1, -1, 1}, {0, 1, 0, 1}, {1, 1}}, {{-1, -1, 1}, {0, 0, 1, 1}, {0, 1}}, {{-1, -1, -1}, {0, 0, 0, 1}, {0, 0}}
};

const GLubyte Indices[] = {
    // Front
    0, 1, 2,
    2, 3, 0,
    // Back
    4, 6, 5,
    4, 5, 7,
    // Left
    8, 9, 10,
    10, 11, 8,
    // Right
    12, 13, 14,
    14, 15, 12,
    // Top
    16, 17, 18,
    18, 19, 16,
    // Bottom
    20, 21, 22,
    22, 23, 20
};

@interface WSQViewController ()
{
    float _curRed;
    BOOL _increasing;
    GLuint _vertexBuffer; GLuint _indexBuffer;
    GLuint _vertexArray;

}
@property (strong, nonatomic) GLKBaseEffect *effect;//着色器。
@property(strong,nonatomic)EAGLContext* eaglContext;


@end

@implementation WSQViewController


- (void)setupGL
{

    /*
    [EAGLContext setCurrentContext:_eaglContext];
    glGenBuffers(1, &_vertexBuffer);//创建一个新的缓存，并且存储在_vertexBuffer

    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);//将_vertexBuffer 和 GL_ARRAY_BUFFER 绑定

    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices),Vertices, GL_STATIC_DRAW);
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
    //着色器哦

    self.effect = [[GLKBaseEffect alloc] init];
     */

    [EAGLContext setCurrentContext:_eaglContext];
    self.effect = [[GLKBaseEffect alloc] init];


    NSDictionary * options = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:YES], GLKTextureLoaderOriginBottomLeft, nil];
    NSError * error;
    NSString *path =
    [[NSBundle mainBundle] pathForResource:@"Leaves" ofType:@"jpg"];
    GLKTextureInfo * info = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];

    if (info == nil)
    {
        NSLog(@"Error loading file: %@", [error localizedDescription]);
    }

    self.effect.texture2d0.name = info.name;
    self.effect.texture2d0.enabled = true;

    // New lines
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);

    // Old stuff
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER,sizeof(Vertices), Vertices,GL_STATIC_DRAW);
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER,sizeof(Indices), Indices,GL_STATIC_DRAW);

    // New lines (were previously in draw)
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition,2, GL_FLOAT, GL_FALSE, sizeof(Vertex), offsetof(Vertex, Position));
    glEnableVertexAttribArray(GLKVertexAttribColor);

    glVertexAttribPointer(GLKVertexAttribColor,4,GL_FLOAT,GL_FALSE,sizeof(Vertex),(const GLvoid*)offsetof(Vertex, Color)); 
    // New line
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0); glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex),
                                                                               (const GLvoid *) offsetof(Vertex, TexCoord));

    //end
    glBindVertexArrayOES(0);


/*
    NSDictionary * options = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:YES], GLKTextureLoaderOriginBottomLeft, nil];
    NSError * error;
    NSString *path =
    [[NSBundle mainBundle] pathForResource:@"Leaves" ofType:@"jpg"];
    GLKTextureInfo * info = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
    
    if (info == nil)
    {
        NSLog(@"Error loading file: %@", [error localizedDescription]);
    }

    self.effect.texture2d0.name = info.name;
    self.effect.texture2d0.enabled = true;

 */
}

-(void)tearDownGL
{
    [EAGLContext setCurrentContext:_eaglContext];
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_indexBuffer);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2 sharegroup: nil];
    GLKView* gView = (GLKView*)self.view;
    gView.context  = _eaglContext;
    //gView.delegate = self;

    gView.drawableMultisample = GLKViewDrawableMultisample4X;
    [self setupGL];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([EAGLContext currentContext] == _eaglContext) {
        [EAGLContext setCurrentContext:nil];

    }
    _eaglContext = nil;
}


/*

-(void)update
{
    if (_increasing) {
        _curRed +=1.0*self.timeSinceLastUpdate;
        // _increasing = NO;
    }
    else
    {
        _curRed -= 1.0*self.timeSinceLastUpdate;
        // _increasing = YES;
    }

    if (_curRed >= 1.0) {
        _curRed = 1.0;
        _increasing = NO;
    }
    if (_curRed <= 0.0) {
        _curRed = 0.0;
        _increasing = YES;
    };

    
}
 
 */


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{

    /*
     if (_increasing) {
     _curRed +=0.01f;
     // _increasing = NO;
     }
     else
     {
     _curRed -= 0.01f;
     // _increasing = YES;
     }

     if (_curRed >= 1.0) {
     _curRed = 1.0;
     _increasing = NO;
     }
     if (_curRed <= 0.0) {
     _curRed = 0.0;
     _increasing = YES;
     }
     */

    /*
    glClearColor(_curRed=0.5, 0.5, 0.5, 0.5);
    glClear(GL_COLOR_BUFFER_BIT);
    glClearDepthf(0.1);
    glCompressedTexImage2D(1, 0.2, .2, 300, 3000, 5, 82222, nil);
    [[UIColor grayColor] setFill];

     */


    /*
    float aspect =
    fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective( GLKMathDegreesToRadians(65.0f), aspect, 4.0f, 10.0f);

    self.effect.transform.projectionMatrix = projectionMatrix;

    float _rotation = 0.0f;
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -6.0f);
    _rotation += (90 * self.timeSinceLastUpdate);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix,GLKMathDegreesToRadians(_rotation), 0, 0, 1);
    //modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix,M_1_PI, 0, 0, 1);

    self.effect.transform.modelviewMatrix = modelViewMatrix;

    [self.effect prepareToDraw];//准备配置着色器。

    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);

    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);

    glEnableVertexAttribArray(GLKVertexAttribPosition);

    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Position));

    glEnableVertexAttribArray(GLKVertexAttribColor);

    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Color));

    // 绘制矩形。
    glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
    */



}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    NSLog(@"timeSinceLastUpdate: %f", self.timeSinceLastUpdate);
    NSLog(@"timeSinceLastDraw: %f", self.timeSinceLastDraw);
    NSLog(@"timeSinceFirstResume: %f", self.timeSinceFirstResume);
    NSLog(@"timeSinceLastResume: %f", self.timeSinceLastResume);
    
    self.paused = !self.paused;
}



@end
