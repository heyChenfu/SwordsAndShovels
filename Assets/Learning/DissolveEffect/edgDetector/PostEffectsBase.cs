
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//希望在编辑器状态下也可以执行该脚本来查看效果
[ExecuteInEditMode]
//所有的屏幕后处理效果都需要绑定在某个摄像机上
[RequireComponent(typeof(Camera))]
public class PostEffectsBase : MonoBehaviour
{

    protected void CheckResource()
    {
        bool isSupported = CheckSupport();
        if (isSupported == false)
        {
            NotSupported();
        }
    }

    protected bool CheckSupport()
    {
        if (SystemInfo.supportsImageEffects == false || SystemInfo.supportsRenderTextures == false)
        {
            Debug.LogWarning("This platform does not support image effects or render textures.");
            return false;
        }
        return true;
    }

    protected void NotSupported()
    {
        enabled = false;
    }

    protected void Start()
    {
        CheckResource();
    }

    //第一个参数指定了该特效需要使用的Shader，第二个参数则是用于后期处理的材质
    protected Material CheckShaderAndCreateMaterial(Shader shader, Material material)
    {
        if (shader == null)
        {
            return null;
        }
        if (shader.isSupported && material && material.shader == shader)
        {
            return material;
        }
        if (!shader.isSupported)
        {
            return null;
        }
        material = new Material(shader);
        material.hideFlags = HideFlags.DontSave;
        return material;
    }
}
