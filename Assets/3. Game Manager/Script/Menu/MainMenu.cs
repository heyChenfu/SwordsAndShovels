using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MainMenu : MonoBehaviour
{
    [SerializeField]
    Animation _mainMenuAnimation;

    public void Start()
    {
        GameManager.Instance.OnGameStateChanged.AddListener(HandleGameStateChanged);

    }

    void HandleGameStateChanged(GameManager.GameState currState, GameManager.GameState preState)
    {
        if (currState == GameManager.GameState.RUNNING && preState == GameManager.GameState.PREGAME)
        {
            FadeOut();
        }

        if (currState == GameManager.GameState.PREGAME && preState != GameManager.GameState.PREGAME)
        {
            FadeIn();
        }
    }

    public void OnFadeInComplete()
    {
        UIManager.Instance.OnMainMenuFadeComplete.Invoke(false);
    }

    public void OnFadeOutComplete()
    {
        UIManager.Instance.SetDummyCameraActive(false);

        UIManager.Instance.OnMainMenuFadeComplete.Invoke(true);
    }

    public void FadeIn()
    {
        UIManager.Instance.SetDummyCameraActive(true);

        _mainMenuAnimation.Stop();
        _mainMenuAnimation.Play("MainMenuFadeIn");
        _mainMenuAnimation.Play();
    }

    public void FadeOut()
    {
        _mainMenuAnimation.Stop();
        _mainMenuAnimation.Play("MainMenuFadeOut");
        _mainMenuAnimation.Play();
    }
}
