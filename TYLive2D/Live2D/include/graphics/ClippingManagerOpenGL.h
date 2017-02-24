/**
* ClippingManagerOpenGL.h
*
*  Copyright(c) Live2D Inc. All rights reserved.
*  [[ CONFIDENTIAL ]]
*/
#ifndef __LIVE2D_CLIPPINGMANAGEROPENGL_H__
#define __LIVE2D_CLIPPINGMANAGEROPENGL_H__

#ifndef __SKIP_DOC__


#if defined(L2D_TARGET_WIN_GL) || defined(L2D_TARGET_ANDROID_ES2) || defined(L2D_TARGET_IPHONE_ES2)


#ifdef L2D_TARGET_ANDROID_ES2
#include <jni.h>
#include <errno.h>
#include <GLES2/gl2.h>
#include <GLES2/gl2ext.h>
#endif

#ifdef L2D_TARGET_IPHONE_ES2
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#endif

#ifdef L2D_TARGET_WIN_GL
#include <windows.h>
#include <GL/GL.h>
#endif

#include "../Live2D.h"
#include "../type/LDRectF.h"
#include "../type/LDPointF.h"
#include "../type/LDVector.h"
#include "../type/LDMatrix44.h"
#include "../type/LDMap.h"
#include "../memory/MemoryParam.h"


namespace live2d
{
	class ModelContext;
	class IDrawData;
	class IDrawContext;
	class DrawDataID;

	class DrawParam_OpenGLES2;
	class ClipContext;
	class TextureInfo;
	class ClippedDrawContext;
	class RenderTextureRes;


	class FrameBufferInfo
	{
	public:
		FrameBufferInfo();
		~FrameBufferInfo();

		int size;
		GLuint colorBuffer;
	};


	class ClippingManagerOpenGL : public LDObject
	{
	public:
		ClippingManagerOpenGL(MemoryParam *memParam);
		~ClippingManagerOpenGL(void);

		static TextureInfo *getChannelFlagAsColor(int channelNo);

		void init(MemoryParam *memParam, ModelContext &mc, LDVector<IDrawData*> *drawDataList, LDVector<IDrawContext*> *drawContextList);

		static GLuint getMaskRenderTexture();

		void setupClip(ModelContext &mc, DrawParam_OpenGLES2 *dp2);

		
		static void releaseStored_notForClientCall() ;

		static void releaseShader();

	public:
		static const int CHANNEL_COUNT = 4;

		static const bool RENDER_TEXTURE_USE_MIPMAP = false;

		GLuint maskRenderTexture;

		LDVector<ClipContext*>* clipContextList ;

		GLuint getColorBuffer();


	private:
		ClipContext* findSameClip(LDVector<DrawDataID*> *clips);
		static void calcClippedDrawTotalBounds(ModelContext &mc, ClipContext *cc);

		void setupLayoutBounds(int usingClipCount);

		static void releaseUnusedRenderTextures();

		void initClipping();

	private:
		static LDMatrix44 *tmpModelToViewMatrix;
		static LDMatrix44 *tmpMatrix2;
		static LDMatrix44 *tmpMatrixForMask;
		static LDMatrix44 *tmpMatrixForDraw;

		static LDRectF *tmpBoundsOnModel;

		static int lastFrameCount ;
		static int totalTexCount ;
		static const int NOT_USED_FRAME = -100;

		static bool firstError_clipInNotUpdate ;

		static int curFrameNo;

		static LDVector<RenderTextureRes*> *maskTextures;

		static LDVector<TextureInfo*>* CHANNEL_COLORS;

		static GLuint colorBuffer;

	};

	class ClipContext : public LDObject
	{
	public:
		ClipContext(MemoryParam *memParam, ClippingManagerOpenGL *owner , ModelContext &mc , LDVector<DrawDataID*> *clips);
		ClipContext();
		~ClipContext(void);

		void addClippedDrawData(MemoryParam *memParam, DrawDataID *id, int drawDataIndex);
		ClippingManagerOpenGL* getClippingManager();

	public:
		
		LDVector<DrawDataID*> *clipIDList;	
		LDVector<int> *clippingMaskDrawIndexList;	

		LDVector<ClippedDrawContext*> *clippedDrawContextList;


		
		bool isUsing;

		
		int layoutChannelNo;
		LDRectF *layoutBounds;

		
		LDRectF *allClippedDrawRect;

		float matrixForMask[16];
		float matrixForDraw[16];//

	private:
		ClippingManagerOpenGL *owner;
	};



	class ClippedDrawContext : public LDObject
	{
	public:
		ClippedDrawContext(DrawDataID *id, int drawDataIndex);
		~ClippedDrawContext(void);

	public:
		DrawDataID *drawDataID;
		int drawDataIndex;
	};


	class RenderTextureRes : public LDObject
	{
	public:
		GLuint tex ;
		int frameNo;

	public:
		RenderTextureRes(int frameNo, GLuint tex);
		~RenderTextureRes(void){};
	};
}


#endif		// __SKIP_DOC__

#endif		// L2D_TARGET_WIN_GL || L2D_TARGET_ANDROID_ES2 || L2D_TARGET_IPHONE_ES2

#endif		// __LIVE2D_CLIPPINGMANAGEROPENGL_H__
