using UnityEngine;
using UnityEngine.UI;

public class PauseMenu : MonoBehaviour
{
    [SerializeField]
    Button ResumeButton;
    [SerializeField]
    Button RestartButton;
    [SerializeField]
    Button QuitButton;

    private void Start()
    {
        ResumeButton.onClick.AddListener(HandleResumtClick);
        RestartButton.onClick.AddListener(HandleRestartClick);
        QuitButton.onClick.AddListener(HandleQuitClick);
    }

    public void HandleResumtClick()
    {
        GameManager.Instance.TogglePause();
    }

    public void HandleRestartClick()
    {
        GameManager.Instance.RestartGame();
    }

    public void HandleQuitClick()
    {
        GameManager.Instance.QuitGame();
    }
}
