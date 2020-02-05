using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;


public class EditorTest : EditorWindow
{
    Object go;

    //通过MenuItem按钮来创建这样的一个对话框
    [MenuItem("ScriptTools/EditorTest")]
    public static void ConfigDialog()
    {
        //GetWindow创建
        EditorWindow.GetWindow(typeof(EditorTest));
    }

    //对话框中的各种内容通过OnGUI函数来设置
    void OnGUI()
    {
        //Label
        GUILayout.Label("Label Test", EditorStyles.boldLabel);
        //通过EditorGUILayout.ObjectField可以接受Object类型的参数进行相关操作
        go = EditorGUILayout.ObjectField(go, typeof(UnityEngine.Object), true);
        //Button
        if (GUILayout.Button("Button Test"))
        {
            if (go != null)
            {
                Debug.Log(go.name);
            }
        }
    }

}
