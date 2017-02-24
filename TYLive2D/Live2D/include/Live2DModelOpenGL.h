


#ifndef __LIVE2D_L2DMODEL_OPENGL_H__
#define __LIVE2D_L2DMODEL_OPENGL_H__

#include "Live2D.h"

#if  defined(L2D_TARGET_IPHONE_ES2) 	\
		|| defined(L2D_TARGET_ANDROID_ES2) 	\
		|| defined(L2D_TARGET_WIN_GL) 	

#include "ALive2DModel.h"
#include "model/ModelImpl.h"

#include "graphics/DrawParam_OpenGLES2.h"


//--------- LIVE2D NAMESPACE ------------
namespace live2d 
{


	class ModelContext ;


	
	class Live2DModelOpenGL : public live2d::ALive2DModel
	{
	public:
		// Constructor
		Live2DModelOpenGL(void) ;

		// Destructor
		virtual ~Live2DModelOpenGL(void) ;

	public:
		
		
		virtual void update();
		
		
		virtual void draw() ;

		
		void setTexture( int textureNo , unsigned int openGLTextureNo ) ;
		
		
		static Live2DModelOpenGL * loadModel( const live2d::LDString & filepath ) ;
		
		static Live2DModelOpenGL * loadModel( const void * buf , int bufSize ) ;

		
		virtual int generateModelTextureNo() ;
		
		
		virtual void releaseModelTextureNo(int no) ;
		
		
		virtual live2d::DrawParam* getDrawParam(){ return drawParamOpenGL; }

		void setMatrix( float*  matrix ) ;

		void setTextureColor(int textureNo, float r, float g, float b, float scale);

	private:
		//Prevention of copy Constructor
		Live2DModelOpenGL( const Live2DModelOpenGL & ) ;
		Live2DModelOpenGL& operator=( const Live2DModelOpenGL & ) ;
		
	private:
		//---- field ----
		live2d::DrawParam_OpenGLES2* 		drawParamOpenGL ;		//

	};
}
//--------- LIVE2D NAMESPACE ------------

#endif		//L2D_TARGET_WIN_GL

#endif		// __LIVE2D_L2DMODEL_OPENGL_H__
