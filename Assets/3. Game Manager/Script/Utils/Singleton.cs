﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Singleton<T> : MonoBehaviour where T : Singleton<T>
{
    private static T instance;
    public static T Instance
    {
        get { return instance; }
    }

    protected virtual void Awake()
    {
        if (instance == null)
        {
            instance = (T)this;
        }
        else
        {
            Debug.LogError("Singleton instantiate multi times!");
        }
    }

    protected virtual void OnDestroy()
    {
        instance = null;
    }

}
