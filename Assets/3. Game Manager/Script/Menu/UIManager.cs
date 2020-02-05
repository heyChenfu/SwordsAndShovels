using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIManager : Singleton<UIManager>
{
    [SerializeField]
    MainMenu _mainMenu;
    [SerializeField]
    PauseMenu _pauseMenu;
    [SerializeField]
    Camera _dummyCamera;

    public Events.EventFadeComplete OnMainMenuFadeComplete;

    public void Start()
    {
        GameManager.Instance.OnGameStateChanged.AddListener(HandleGameStateChanged);
    }

    void HandleGameStateChanged(GameManager.GameState currState, GameManager.GameState preState)
    {
        _pauseMenu.gameObject.SetActive(currState == GameManager.GameState.PAUSED ? true : false);
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space) || Input.touchCount > 0)
        {
            if (GameManager.Instance.CurrGameStatus == GameManager.GameState.PREGAME)
            {
                GameManager.Instance.StartGame();
            }
        }
    }

    public void SetDummyCameraActive(bool active)
    {
        _dummyCamera.gameObject.SetActive(active);
    }
}
