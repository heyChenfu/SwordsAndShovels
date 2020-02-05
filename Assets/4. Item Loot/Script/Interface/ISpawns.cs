using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface ISpawns
{
   Rigidbody itemSpawned { get; set; }
    Renderer itemMaterial { get; set; }
    ItemPickUp itemType { get; set; }

    void CreateSpawn();

}
