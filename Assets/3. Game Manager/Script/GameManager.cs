using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.SceneManagement;

public class GameManager : Singleton<GameManager>
{
    public enum GameState
    {
        PREGAME,
        RUNNING,
        PAUSED
    }

    public GameObject[] systemPrefabs;
    public Events.EventGameState OnGameStateChanged;

    private List<GameObject> _instanceSystemPrefab;
    private List<AsyncOperation> _loadOperation;
    GameState _currentGameStatus = GameState.PREGAME;
    private string _currentLevelName = string.Empty;

    public GameState CurrGameStatus
    {
        get { return _currentGameStatus; }
        private set { _currentGameStatus = value; }
    }

    private void Start()
    {
        DontDestroyOnLoad(gameObject);
        _instanceSystemPrefab = new List<GameObject>();
        _loadOperation = new List<AsyncOperation>();

        InstantiateSystemPrefab();

        UIManager.Instance.OnMainMenuFadeComplete.AddListener(HandleMainMenuFadeComplete);
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            if (GameManager.Instance.CurrGameStatus != GameManager.GameState.PREGAME)
            {
                TogglePause();
            }
        }
    }

    void OnLoadOprationComplete(AsyncOperation ao)
    {
        if (_loadOperation.Contains(ao))
        {
            _loadOperation.Remove(ao);
            if (_loadOperation.Count == 0)
            {
                UpdateState(GameState.RUNNING);
            }
        }
        Debug.Log("Load Complete");
    }

    void OnUnLoadOprationComplete(AsyncOperation ao)
    {
        Debug.Log("UnLoad Complete");
    }

    /*
     * 当MainMenu淡入淡出后执行, 可以掩盖场景让我们安全的卸载和加载场景
     */
    void HandleMainMenuFadeComplete(bool fadeOut)
    {
        if (!fadeOut)
        {
            UnLoadLevel(_currentLevelName);
        }
    }

    void UpdateState(GameState state) 
    {
        GameState _previosGameState = _currentGameStatus;
        _currentGameStatus = state;
        switch (_currentGameStatus)
        {
            case GameState.PREGAME:
                Time.timeScale = 1;
                break;
            case GameState.RUNNING:
                Time.timeScale = 1;
                break;
            case GameState.PAUSED:
                Time.timeScale = 0;
                break;
            default:

                break;
        }

        OnGameStateChanged.Invoke(_currentGameStatus, _previosGameState);
    }

    void InstantiateSystemPrefab()
    {
        GameObject prefabInstance;
        for (int i = 0; i < systemPrefabs.Length; i++)
        {
            prefabInstance = Instantiate(systemPrefabs[i]);
            _instanceSystemPrefab.Add(prefabInstance);
        }
    }

    public void LoadLevel(string levelName)
    {
        AsyncOperation op = SceneManager.LoadSceneAsync(levelName, LoadSceneMode.Additive);
        if (op == null)
        {
            Debug.LogError("LoadScene Fail" + levelName);
            return;
        }
        _loadOperation.Add(op);
        op.completed += OnLoadOprationComplete;
        _currentLevelName = levelName;
    }

    public void UnLoadLevel(string levelName)
    {
        AsyncOperation op = SceneManager.UnloadSceneAsync(levelName);
        if (op == null) return;
        op.completed += OnUnLoadOprationComplete;

    }

    protected override void OnDestroy()
    {
        base.OnDestroy();
        for (int i = 0; i < _instanceSystemPrefab.Count; i++)
        {
            Destroy(_instanceSystemPrefab[i]);
        }
        //清除引用
        _instanceSystemPrefab.Clear();
    }

    public void StartGame()
    {
        LoadLevel("Main");
    }
    

    public void TogglePause()
    {
        UpdateState(_currentGameStatus == GameState.RUNNING ? GameState.PAUSED : GameState.RUNNING);
    }

    public void RestartGame() {
        UpdateState(GameState.PREGAME);
    }

    public void QuitGame()
    {
        Application.Quit();
    }
}
