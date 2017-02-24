
#ifndef __LIVE2D_L2DMODEL_ANDROIDES2_H__
#define __LIVE2D_L2DMODEL_ANDROIDES2_H__



#include "Live2D.h"				

#ifdef L2D_TARGET_ANDROID_ES2	
#include "ALive2DModel.h"
#include "model/ModelImpl.h"
#include "graphics/DrawParam_OpenGLES2.h"


//--------- LIVE2D NAMESPACE ------------
namespace live2d
{

	class ModelContext ;


	
	class Live2DModelAndroidES2 : public live2d::ALive2DModel
	{
	public:
		// Constructor
		Live2DModelAndroidES2(void) ;

		// Destructor
		virtual ~Live2DModelAndroidES2(void) ;

	public:
		void setMatrix( float* matrix4x4 )
		{
			drawParamAndroid->setMatrix(matrix4x4);
		}
		
		
		virtual void update();

		
		virtual void draw() ;

		
		void setTexture( int textureNo , GLuint openGLTextureNo ) ;

		
		static Live2DModelAndroidES2 * loadModel( const live2d::LDString & filepath ) ;
		
		static Live2DModelAndroidES2 * loadModel( const void * buf , int bufSize ) ;

		
		virtual int generateModelTextureNo() ;

		
		virtual void releaseModelTextureNo(int no) ;

		
		virtual live2d::DrawParam* getDrawParam(){ return drawParamAndroid ; }

	private:
		// Prevention of copy Constructor
		Live2DModelAndroidES2( const Live2DModelAndroidES2 & ) ;
		Live2DModelAndroidES2& operator=( const Live2DModelAndroidES2 & ) ;
	private:
		//---- field ----
		live2d::DrawParam_OpenGLES2 * drawParamAndroid ;

	};
}
//--------- LIVE2D NAMESPACE ------------


#endif//L2D_TARGET_ANDROID_ES2

#endif		// __LIVE2D_L2DMODEL_ANDROIDES2_H__
