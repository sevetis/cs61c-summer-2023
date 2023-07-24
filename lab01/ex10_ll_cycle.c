#include <stddef.h>
#include "ex10_ll_cycle.h"

int ll_has_cycle(node *head) {
    /* TODO: Implement ll_has_cycle */
    if (head != NULL) {
        node *slow = head, *fast = head;
        while (fast -> next != NULL && fast -> next -> next != NULL) {
            slow = slow -> next;
            fast = fast -> next -> next;
            if (slow == fast) {
                return 1;
            }
        }
    }
    return 0;
}
