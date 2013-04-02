#ifndef INC_CTask_H
#define  INC_CTask_H

#include <clientlib/ClientExport.h>
#include <clientlib/SevenCBoxClientConfig.h>
#include <string>
#include <clientlib/tinythread.h>
#include <clientlib/HttpClientCommon.h>
#include <clientlib/ITaskExecuter.h>
using namespace std;
class EXTERNCLASS CTask
{
private:
	 int task_id;
	//��������
	 string task_name;
	//�ļ�id
	 string task_file_id;
	//�ļ�����
	 string task_file_name; 
	//����Ŀ¼id
	 string task_file_pid;
	//����ٷֱ�
	int task_percentage;
	//�ϴ��������أ�Ĭ���ϴ�true
	 bool task_is_upload;
	//����·��
	string task_local_path;
	//����״̬0:ֹͣ,1:���ڽ���,2:��ͣ,3:���
	int task_state;
	//��ǰ��Ƭ�ļ�����
	int task_priority;
	string task_pre_sname;
	//�����ٶ�
	float task_transf_speed;
	//�ļ���С
	long task_file_size;
	int task_type;
	//�ļ�MD5ֵ
	long task_transfered_size;
	string task_file_md5;
	int task_is_bkground;
	long skip_on_start;
	bool started;
	bool task_tobedelete;
	time_t start_time;
	time_t stop_time;
	int task_max_speed;
	int task_retry;
	bool task_execute_after_downloaded;
	TaskCallBack * task_callback;
	ITaskExecuter * task_executer;
	
public:
	tthread::recursive_mutex * task_recursive_mutex;
	//(task_id,task_name,task_file_id,task_file_name,task_file_pid,task_trans_dir,task_local_path);
	//CTask(const int & itask_id, const string &stask_name,const int & itask_percentage,const string & stask_file_id, const string & stask_file_name,const string & stask_file_pid,const string & stask_local_path,const bool & btask_trans_dir=true);
	CTask(const int & itask_id, const string &stask_name,const int & itask_percentage,const string & stask_file_id, const string & stask_file_name,const string & stask_file_pid,const string & stask_local_path,const bool & btask_trans_dir=true,const int task_init_state = 0,const int split_index=-1,string  pre_sname="",int is_background=0,int itask_type=0);
	~CTask(void);
	CTask(CTask * task);
	CTask();
	//friend class CTaskManager;
	TaskCallBack * GetCallBack();
	int GetTaskType();
	long GetDuration();
	const int GetTaskId();
	int GetTaskPercentage();
	const char * GetTaskName();
	const char * GetFileId();
	const char * GetFileName();
	const int GetTaskState();
	const char * GetFolderId();
	const char * GetFileLocalPath();
	const char * GetPreSName();
	long GetSkipOnStart();
	bool IsUpload();
	time_t GetStartTime();
	int GetPriority();
	float GetTrransfSpeed();
	long GetTaskFileSize();
	string GetFileMD5();
	int GetRetry();
	bool IsRunning();
	bool IsBackGround();
	int GetMaxSpeed();
	void SetTaskType(int itask_type);
	void SetPriority(int index);
	void ChangePercentage(int percent);
	void SetFileId(string & file_id);
	void SetPreSName(const string & pre_sname);
	void SetTrransfSpeed(float speed);
	void AddTransferedSize(long size);
	void SetStartState(bool started);
	void SetSkipOnStart(long skip);
	void ChangeState(const int state);
	void SetRetry(int retry);
	void UpdateView();
	void Start();
	void Stop();
	void SetMaxSpeed(int speed);
	void SetToBeDelete();
	bool IsToBeDelete();
	bool IsStarted();
	void SetCallBack(TaskCallBack * ptr);
	void Complete();
	void DeleteThread();
	void SetOpenAfterDownloaded(bool open_after_downloaded);
	bool OpenAfterDownloaded();
};

#endif