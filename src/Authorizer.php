<?php

/**
 * @file
 * Contains \Drupal\scheduler\Authorizer.
 */

namespace Drupal\scheduler;

use Drupal\node\NodeInterface;

/**
 * Node publication authorization service.
 */
class Authorizer {

  /**
   * Checks whether a scheduled action on a node is allowed.
   *
   * This provides a way for other modules to prevent scheduled publishing or
   * unpublishing, by implementing hook_scheduler_allow_publishing() or
   * hook_scheduler_allow_unpublishing().
   *
   * @see hook_scheduler_allow_publishing()
   * @see hook_scheduler_allow_unpublishing()
   *
   * @param \Drupal\node\NodeInterface $node
   *   The node on which the action is to be performed.
   * @param string $action
   *   The action that needs to be checked. Can be 'publish' or 'unpublish'.
   *
   * @return bool
   *   TRUE if the action is allowed, FALSE if not.
   */
  public function isAllowed(NodeInterface $node, $action) {
    // Default to TRUE.
    $result = TRUE;
    // Check that other modules allow the action.
    $hook = 'scheduler_allow_' . $action . 'ing';
    foreach (\Drupal::moduleHandler()->getImplementations($hook) as $module) {
      $function = $module . '_' . $hook;
      $result &= $function($node);
    }

    return $result;
  }

}
