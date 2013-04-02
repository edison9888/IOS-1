#ifndef _INC_CASYNREQUEST_H
#define _INC_CASYNREQUEST_H
#include <json/json.h>
#include <clientlib/ClientExport.h>
#include <clientlib/tinythread.h>
#include <string>
#include <clientlib/HttpClientCommon.h>
using namespace Json;
using namespace tthread;
using namespace std;
//�첽������
class EXTERNCLASS CAsynRequest
{
public:

	//************************************
	// Method:    CAsynRequest
	// FullName:  CAsynRequest::CAsynRequest
	// Access:    public 
	// Returns:   
	// Qualifier:
	// Parameter: Value & header	ͷ��Ϣ
	// Parameter: Value & params	�ֶ���Ϣ
	// Parameter: SCBoxCallBack callback	�ص�����
	// Parameter: void * any_ptr	����ָ�룬��Ե�ֲ����Ĵ����ص�����
	//************************************
	
	CAsynRequest(const string * uri,const Value * params,const Value * header ,SCBoxCallBack callback=NULL,void * any_ptr=NULL);
	CAsynRequest(CAsynRequest * request);
	~CAsynRequest(void);
	
	const Value & GetParams();
	const Value & GetHeader();
	const string & GetUri();
	bool IsOver();

	SCBoxCallBack GetCallBackFunc();
	void * GetAnyPointer();
	My_Progress_Func GetProgressFunc();
	void ExecutePost();


private:
	
	friend class SevenCBoxClient;
	thread * pThread;
	bool b_IsRunning;
	const string * requestUri;
	const Value * requestParams;
	const Value * requestHeader;
	SCBoxCallBack callbackFunc;
	void * any_pointer;
};

#endif